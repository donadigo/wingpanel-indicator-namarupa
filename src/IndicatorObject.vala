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

public class AyatanaCompatibility.IndicatorObject : Object, IndicatorIface {
    private IndicatorAyatana.Object object;
    private Gee.HashMap<unowned IndicatorAyatana.ObjectEntry, Indicator> entries;
    private string name;

    public IndicatorObject (IndicatorAyatana.Object object, string name) {
        this.object = object;
        this.name = name;

        entries = new Gee.HashMap<unowned IndicatorAyatana.ObjectEntry, Indicator> ();

        load_entries ();

        object.entry_added.connect (on_entry_added);
        object.entry_removed.connect (on_entry_removed);
    }

    public string get_name () {
        return name;
    }

    public Gee.Collection<Indicator> get_entries () {
       return entries.values;
    }

    private void load_entries () {
        List<unowned IndicatorAyatana.ObjectEntry> list = object.get_entries ();

        foreach (var entry in list)
            entries.set (entry, create_entry (entry));
    }

    private void on_entry_added (IndicatorAyatana.Object object, IndicatorAyatana.ObjectEntry entry) {
        assert (this.object == object);

        var entry_widget = create_entry (entry);
        entries.set (entry, entry_widget);

        entry_added (entry_widget);
    }

    private void on_entry_removed (IndicatorAyatana.Object object, IndicatorAyatana.ObjectEntry entry) {
        assert (this.object == object);

        var entry_widget = entries.get (entry);

        if (entry_widget != null) {
            entries.unset (entry);
            entry_removed (entry_widget);
        } else {
            warning ("Could not remove panel entry for %s (%s). No entry found.", name, entry.name_hint);
        }
    }

    private Indicator create_entry (IndicatorAyatana.ObjectEntry entry) {
        return new Indicator (entry, object, this);
    }

}
