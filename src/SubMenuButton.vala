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

public class AyatanaCompatibility.SubMenuButton : Gtk.Button {
    private Gtk.Label button_label;

    private new Gtk.Image image;

    public SubMenuButton (string caption) {
        this.hexpand = true;

        var box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        box.hexpand = true;

        button_label = new Gtk.Label.with_mnemonic (caption);
        button_label.set_mnemonic_widget (this);
        button_label.use_markup = true;
        button_label.margin_start = 6;

        image = new Gtk.Image ();
        image.halign = Gtk.Align.END;
        try {
            Gtk.IconTheme icon_theme = Gtk.IconTheme.get_default ();
            image.pixbuf = icon_theme.load_icon ("pan-end-symbolic", 16, 0);
        } catch (Error e) {
            warning (e.message);
        }
        image.margin_end = 6;

        box.add (button_label);
        box.pack_end (image);

        this.add (box);

        var style_context = this.get_style_context ();
        style_context.add_class (Gtk.STYLE_CLASS_MENUITEM);
        style_context.remove_class (Gtk.STYLE_CLASS_BUTTON);
        style_context.remove_class ("text-button");
    }

    public void set_caption (string caption) {
        button_label.set_label (Markup.escape_text (caption));
    }

    public string get_caption () {
        return button_label.get_label ();
    }
}
