/* widgets/difficulty-selector.vala
 *
 * Copyright 2022 Jamie Murphy
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

namespace WindowPainter {
    [GtkTemplate (ui = "/dev/jamiethalacker/window_painter/difficulty-selector.ui")]
    public class DifficultySelector : Adw.PreferencesPage {
        [GtkChild]
        private unowned Gtk.Stack stack;
        [GtkChild]
        private unowned Gtk.ListBox listbox;

        [GtkCallback]
        public void create_custom_board () {
            stack.set_visible_child_name ("custom");
        }

        [GtkCallback]
        public void activate_row (Adw.ActionRow source) {
            var length = 0;

            while (listbox.get_row_at_index (length) != null) {
                length++;
            }

            for (var i = 0; i < length; i++) {
                if (listbox.get_row_at_index (i) == source) {
                    Application.settings.set_int ("difficulty", i);
                    Signals.get_default ().new_game ();
                    Signals.get_default ().switch_stack ("gameboard");
                }
            }
        }

        public DifficultySelector () {
            Object ();
            stack.set_visible_child_name ("main");
        }

        construct {
            listbox.row_selected.connect (() => {
               listbox.unselect_all ();
            });
        }
    }
}
