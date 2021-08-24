/*
 * Copyright (c) 2011-2015 Wingpanel Developers (http://launchpad.net/wingpanel)
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public
 * License along with this program; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin Street - Fifth Floor,
 * Boston, MA 02110-1301, USA.
 */
/*NAMARUPA */

public class AyatanaCompatibility.Indicator : IndicatorButton {
    public string code_name { get; construct; }
    public string display_name { get; construct; }
    public string description { get; construct; }
    private IndicatorButton icon;

    private Gtk.Stack main_stack;
    private Gtk.Grid main_grid;

    private unowned IndicatorAyatana.ObjectEntry entry;
    private unowned IndicatorAyatana.Object parent_object;
    private IndicatorIface indicator;
    private string entry_name_hint;

    private Gtk.Popover popover;

    private Gee.HashMap<Gtk.Widget, Gtk.Widget> menu_map;
	private Gee.HashMap<Gtk.Widget, Gtk.Widget> submenu_map;

	 const int MAX_ICON_SIZE = 22;

	//group radiobuttons
    private Gtk.RadioButton? group_radio = null;
	 
    public Indicator (IndicatorAyatana.ObjectEntry entry, IndicatorAyatana.Object obj, IndicatorIface indicator) {
        string name_hint = entry.name_hint;
        if (name_hint == null) {
            var current_time = new DateTime.now_local ();
            name_hint = current_time.hash ().to_string ();
        }

        Object (code_name: "%s%s".printf ("ayatana-", name_hint),
                display_name: "%s%s".printf ("ayatana-", name_hint),
                description: _("Ayatana compatibility indicator"));
        this.entry = entry;
        this.indicator = indicator;
        this.parent_object = obj;
        this.menu_map = new Gee.HashMap<Gtk.Widget, Gtk.Widget> ();
        entry_name_hint = name_hint;

        if (entry.menu == null) {
            critical ("Indicator: %s has no menu widget.", entry_name_hint);
            return;
        }

        add_events (Gdk.EventMask.BUTTON_PRESS_MASK);

        var image = entry.image as Gtk.Image;

        if (image != null) {
            /*
             * images holding pixbufs are quite frequently way too large, so we whenever a pixbuf
             * is assigned to an image we need to check whether this pixbuf is within reasonable size
             */
            if (image.storage_type == Gtk.ImageType.PIXBUF) {
                image.notify["pixbuf"].connect (() => {
                    ensure_max_size (image);
                });

                ensure_max_size (image);
            }

            image.pixel_size = MAX_ICON_SIZE;

            set_widget (IndicatorButton.WidgetSlot.IMAGE, image);
        }

        var label = entry.label;

        if (label != null && label is Gtk.Label) {
            set_widget (IndicatorButton.WidgetSlot.LABEL, label);
        }

        scroll_event.connect (on_scroll);
        button_press_event.connect (on_button_press);

        /*
         * Workaround for buggy indicators: this menu may still be part of
         * another panel entry which hasn't been destroyed yet. Those indicators
         * trigger entry-removed after entry-added, which means that the previous
         * parent is still in the panel when the new one is added.
         */
        if (entry.menu.get_attach_widget () != null) {
            entry.menu.detach ();
        }

        this.visible = true;
    }


    public string name_hint () {
        return entry_name_hint;
    }

    public bool on_button_press (Gdk.EventButton event) {
        get_popover ().show_all ();
        print ("ON BUTTON PRESS\n");
        if (event.button == Gdk.BUTTON_MIDDLE) {
            parent_object.secondary_activate (entry, event.time);

            return Gdk.EVENT_STOP;
        }

        return Gdk.EVENT_PROPAGATE;
    }

    public bool on_scroll (Gdk.EventScroll event) {
        parent_object.entry_scrolled (entry, 1, (IndicatorAyatana.ScrollDirection)event.direction);

        return Gdk.EVENT_PROPAGATE;
    }

    int position = 0;
    public Gtk.Widget? get_popover () {
        if (popover == null) {
            bool reloaded = false;
            icon.parent.parent.enter_notify_event.connect ((w, e) => {
                if (!reloaded && e.mode != Gdk.CrossingMode.TOUCH_BEGIN) {
                    /*
                     * workaround for indicators (e.g. dropbox) that only update menu children after
                     * the menu is popuped
                     */
                    reloaded = true;
                    entry.menu.popup_at_widget (icon.parent, 0, 0);
                }

                return Gdk.EVENT_PROPAGATE;
            });

            main_stack = new Gtk.Stack ();
            main_stack.map.connect (() => {
                main_stack.set_visible_child (main_grid);
                reloaded = false;
            });
            main_grid = new Gtk.Grid ();
            main_stack.add (main_grid);

            foreach (var item in entry.menu.get_children ()) {
                on_menu_widget_insert (item);
            }

            entry.menu.insert.connect (on_menu_widget_insert);
            entry.menu.remove.connect (on_menu_widget_remove);

            popover = new Gtk.Popover (this);
            popover.add (main_stack);
        }

        return popover;
    }

    private void on_menu_widget_insert (Gtk.Widget item) {
        var w = convert_menu_widget (item);

        if (w != null) {
            menu_map.set (item, w);
            main_grid.attach (w, 0, position++, 1, 1);
            /* menuitem not visible */
            if (!item.get_visible ()) {
                w.no_show_all = true;
                w.hide ();
            } else {
                w.show ();
            }
        }
    }

    private void on_menu_widget_remove (Gtk.Widget item) {
        var w = menu_map.get (item);

        if (w != null) {
            main_grid.remove (w);
            menu_map.unset (item);
        }
    }

    private Gtk.Image? check_for_image (Gtk.Container container) {
        foreach (var c in container.get_children ()) {
            if (c is Gtk.Image) {
                return (c as Gtk.Image);
            } else if (c is Gtk.Container) {
                return check_for_image ((c as Gtk.Container));
            }
        }

        return null;
    }

    private void connect_signals (Gtk.Widget item, Gtk.Widget button) {
        item.show.connect (() => {
            button.no_show_all = false;
            button.show ();
        });
        item.hide.connect (() => {
            button.no_show_all = true;
            button.hide ();
        });
        item.state_flags_changed.connect ((type) => {
            button.set_state_flags (item.get_state_flags (), true);
        });
    }

    /* convert the menuitems to widgets that can be shown in popovers */
    private Gtk.Widget? convert_menu_widget (Gtk.Widget item) {
        /* separator are GTK.SeparatorMenuItem, return a separator */
        if (item is Gtk.SeparatorMenuItem) {
            var separator =  new Gtk.Separator (Gtk.Orientation.HORIZONTAL);

            connect_signals (item, separator);

            return separator;
        }

        /* all other items are genericmenuitems */
        string label = ((Gtk.MenuItem)item).get_label ();
        label = label.replace ("_", "");

        /*
         * get item type from atk accessibility
         * 34 = MENU_ITEM  8 = CHECKBOX  32 = SUBMENU 44 = RADIO
         */
		const int ATK_CHECKBOX = 8;
		const int ATK_RADIO = 44;
		
        var atk = item.get_accessible ();
        Value val = Value (typeof (int));
        atk.get_property ("accessible_role", ref val);
        var item_type = val.get_int ();

        var state = item.get_state_flags ();

		//RAZ group_radio
       group_radio = (item_type == ATK_RADIO)? group_radio:null;
		
        /* detect if it has a image */
        Gtk.Image? image = null;
        var child = ((Gtk.Bin)item).get_child ();

        if (child != null) {
            if (child is Gtk.Image) {
                image = (child as Gtk.Image);
            } else if (child is Gtk.Container) {
                image = check_for_image ((child as Gtk.Container));
            }
        }

        if (item_type == ATK_CHECKBOX) {
            
			var box_switch = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 5);
			var lbl = new Gtk.Label (label);
            var button = new Gtk.Switch ();
			box_switch.pack_start (lbl, true, true, 5);
			box_switch.pack_end (button, false, false, 5);
			lbl.set_halign (Gtk.Align.START); 
			lbl.margin_start = 6;
			//init
			var active= ((Gtk.CheckMenuItem)item).get_active ();
			button.set_active(active);

			button.state_set.connect ((b) => {
                ((Gtk.CheckMenuItem)item).set_active (b);
				return(false);
            });

			connect_signals (item, button);
            ((Gtk.CheckMenuItem)item).toggled.connect (() => {
                button.active = ((Gtk.CheckMenuItem)item).get_active ();
            });

            return box_switch;
        }

		//RADIO BUTTON
		if (item_type == ATK_RADIO) {
		    var button = new Gtk.RadioButton.with_label_from_widget (group_radio,label);
		    button.margin = 5;
		    button.set_margin_start(10);
		    
		    if (group_radio == null) {
		        group_radio = button;
		    }
		    var active= ((Gtk.CheckMenuItem)item).get_active ();
	        button.set_active(active);
			
		    // do not remove
			button.clicked.connect (() => {
				item.activate ();
			});
			
		    button.activate.connect (() => {
				item.activate();
				((Gtk.RadioMenuItem)item).set_active (button.get_active ());
            });
			
		    return button;
		}
		
        /* convert menuitem to a indicatorbutton */
        if (item is Gtk.MenuItem) {
            Gtk.ModelButton button;

            if (image != null && image.pixbuf == null && image.icon_name != null) {
                try {
                    Gtk.IconTheme icon_theme = Gtk.IconTheme.get_default ();
                    image.pixbuf = icon_theme.load_icon (image.icon_name, 16, 0);
                } catch (Error e) {
                    warning (e.message);
                }
            }
			button = new Gtk.ModelButton();
			button.text = label;
			var hbox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 3);
            if (image != null && image.pixbuf != null) {
				var img= new Gtk.Image.from_pixbuf(image.pixbuf);
				
				hbox.add(button);
				hbox.add(img);
				//Modelbutton = text OR icon not both
                //button.icon = (image.pixbuf);
            } 
            ((Gtk.CheckMenuItem)item).notify["label"].connect (() => {
                button.text = ((Gtk.MenuItem)item).get_label ().replace ("_", "");
            });

            button.set_state_flags (state, true);

            var submenu = ((Gtk.MenuItem)item).submenu;
			var sub_list = new Gtk.ListBox ();
			
            if (submenu != null) {
                var scroll_sub = new Gtk.ScrolledWindow (null, null);
                scroll_sub.set_policy (Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);
                scroll_sub.add (sub_list);
				
                var back_button = new Gtk.ModelButton();
		    back_button.text = (_("Back"));
		    back_button.inverted = true;
		    back_button.menu_name = "main_grid";
                back_button.clicked.connect (() => {
                    main_stack.set_visible_child (main_grid);
                });
                sub_list.add (back_button);
                sub_list.add (new Gtk.Separator (Gtk.Orientation.HORIZONTAL));
				
				//adding submenu items
				foreach (var sub_item in submenu.get_children ()) {
					var sub_menu_item = convert_menu_widget (sub_item);
					connect_signals (sub_item, sub_menu_item);
					sub_list.add (sub_menu_item);
				}
				
				submenu.insert.connect ((sub_item) => {
                    var sub_menu_item = convert_menu_widget (sub_item);

                    if (sub_menu_item != null) {
						submenu_map.set(item,sub_menu_item);
                        connect_signals (sub_item, sub_menu_item);
                        sub_list.add (sub_menu_item);
                    }
                });
				
		     submenu.remove.connect ((item) => {
			 var w = menu_map.get (item);

        		 if (w != null) {
            		     sub_list.remove (w);
            		     submenu_map.unset (item);
        		 }	
		    });
               
                main_stack.add (scroll_sub);
				//Button opening the submenu
                button = new Gtk.ModelButton();
		      button.text = label;
		      button.menu_name = "submenu";
                button.clicked.connect (() => {
                    main_stack.set_visible_child (scroll_sub);
                    main_stack.show_all ();
                });
            } else {
                button.clicked.connect (() => {
                    //close ();
                    item.activate ();
                });
            }

            connect_signals (item, button);
			if ((image != null && image.pixbuf != null)) {
				return hbox;}
            else {return button;}
            
        }

        return null;
    }

    //  public override void opened () {
    //  }

    //  public override void closed () {
    //  }

    private void ensure_max_size (Gtk.Image image) {
        var pixbuf = image.pixbuf;

        if (pixbuf != null && pixbuf.get_height () > MAX_ICON_SIZE) {
            image.pixbuf = pixbuf.scale_simple ((int)((double)MAX_ICON_SIZE / pixbuf.get_height () * pixbuf.get_width ()),
                                                MAX_ICON_SIZE, Gdk.InterpType.HYPER);
        }
    }
}
