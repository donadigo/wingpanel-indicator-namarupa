/*-
 * Copyright (c) 2015 Wingpanel Developers (http://launchpad.net/wingpanel)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Library General Public License as published by
 * the Free Software Foundation, either version 2.1 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

public class AyatanaCompatibility.MetaIndicator : Wingpanel.Indicator {
    private Gee.HashSet<string> blacklist;
    private IndicatorFactory indicator_loader;
    private Gtk.Box box;
    private Gtk.Label label;
    private Gtk.Stack stack;
    private Gtk.Box? main_box = null;

    public MetaIndicator () {
        Object (code_name: "namarupa",
                display_name: _("Namarupa"),
                description:_("Ayatana Compatibility Meta Indicator"));

        load_blacklist ();
        indicator_loader = new IndicatorFactory ();

        visible = true;
        var indicators = indicator_loader.get_indicators ();

        foreach (var indicator in indicators) {
            load_indicator (indicator);
        }
    }

    public override Gtk.Widget get_display_widget () {
        return new Gtk.Image.from_icon_name ("view-more-horizontal-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
    }

    private void load_indicator (IndicatorIface indicator) {
        var entries = indicator.get_entries ();

        foreach (var entry in entries) {
            create_entry (entry);
        }

        indicator.entry_added.connect (create_entry);
        indicator.entry_removed.connect (delete_entry);
    }

    private void create_entry (Indicator indicator) {
        if (blacklist.contains (indicator.name_hint ())) {
            return;
        }

        get_widget ();
        box.add (indicator);
        box.show_all ();

        switch_stack (true);
    }

    private void delete_entry (Indicator indicator) {
        get_widget ();

        switch_stack (false);

        foreach (var fbc in box.get_children ()) {
            var child = (Gtk.Widget)fbc;
            if (child is Indicator && ((Indicator)child).code_name == indicator.code_name) {
                child.destroy ();
                break;
            }
        }
    }

    public override Gtk.Widget? get_widget () {
        if (main_box == null) {
            main_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            main_box.set_size_request (200, -1);

            label = new Gtk.Label ("No tray icons…");
            label.get_style_context ().add_class (Granite.STYLE_CLASS_H3_LABEL);
            label.sensitive = false;
            label.valign = Gtk.Align.CENTER;
            label.margin_top = label.margin_bottom = 12;
            label.margin_start = label.margin_end = 6;
            label.show_all ();

            box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);
            box.margin = 6;
            box.margin_start = 12;
            box.set_spacing (10);

            stack = new Gtk.Stack ();
            stack.hexpand = true;
            stack.add_named (box, "box");
            stack.add_named (label, "label");
            main_box.add (stack);

            switch_stack (false);

            // TODO: var settings_btn = new Gtk.ModelButton ();
            // TODO: settings_btn.text = _("Settings…");
            //TODO: settings_btn.clicked.connect (show_settings);

            // TODO: main_box.add (new Wingpanel.Widgets.Separator ());
            // TODO: main_box.add (settings_btn);
        }

        return main_box;
    }

    private void switch_stack (bool show) {
        if (show) {
            stack.set_visible_child_name ("box");
        } else {
            stack.set_visible_child_name ("label");
        }
    }

    public override void opened () {
    }

    public override void closed () {
    }

    private void load_blacklist () {
        blacklist = new Gee.HashSet<string> ();
        var blacklist_file = File.new_for_path ("/etc/wingpanel.d/ayatana.blacklist");
        foreach (var entry in get_restrictions_from_file (blacklist_file)) {
            blacklist.add (entry);
        }
    }

    private string[] get_restrictions_from_file (File file) {
        var restrictions = new string[] {};

        if (file.query_exists ()) {
            try {
                var dis = new DataInputStream (file.read ());
                string? line = null;

                while ((line = dis.read_line ()) != null) {
                    if (line.strip () != "") {
                        restrictions += line;
                    }
                }
            } catch (Error error) {
                warning ("Unable to load restrictions file %s: %s\n", file.get_basename (), error.message);
            }
        }

        return restrictions;
    }

    // TODO: Plug for Namarupa.
    /*private void show_settings () {
        close ();

        try {
            AppInfo.launch_default_for_uri ("settings://namarupa", null);
        } catch (Error e) {
            warning ("Failed to open notifications settings: %s", e.message);
        }
    }*/

}

public Wingpanel.Indicator? get_indicator (Module module, Wingpanel.IndicatorManager.ServerType server_type) {
    if (server_type != Wingpanel.IndicatorManager.ServerType.SESSION)
        return null;

    debug ("Activating AyatanaCompatibility Meta Indicator");
    var indicator = new AyatanaCompatibility.MetaIndicator ();
    return indicator;
}
