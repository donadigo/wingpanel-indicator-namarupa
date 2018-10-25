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

public class AyatanaCompatibility.IndicatorFactory : Object, IndicatorLoader {
    private Gee.Collection<IndicatorIface> indicators;

    public IndicatorFactory () {
    }

    public Gee.Collection<IndicatorIface> get_indicators () {
        if (indicators == null) {
            indicators = new Gee.LinkedList<IndicatorIface> ();
            load_indicator (File.new_for_path (Constants.AYANATAINDICATORDIR), "libapplication.so");
        }

        return indicators.read_only_view;
    }

    private void load_indicator (File parent_dir, string name) {
        string indicator_path = parent_dir.get_child (name).get_path ();
        if (!File.new_for_path (indicator_path).query_exists ()) {
            debug ("No ayatana support possible because there is no Indicator Library: %s", name);
            return;
        }
        IndicatorAyatana.Object indicator = null;

        debug ("Loading Indicator Library: %s", name);
        indicator = new IndicatorAyatana.Object.from_file (indicator_path);

        if (indicator != null)
            indicators.add (new IndicatorObject (indicator, name));
        else
            debug ("Unable to load %s: invalid object.", name);

    }
}
