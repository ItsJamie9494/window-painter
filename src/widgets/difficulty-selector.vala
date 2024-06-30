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
        [GtkChild]
        private unowned Gtk.ListBox custom_listbox;
        [GtkChild]
        private unowned Gtk.Entry rowcol_count;
        [GtkChild]
        private unowned Gtk.Entry move_count;

        private bool is_infinite_mode = Application.settings.get_boolean ("infinite-mode");

        [GtkCallback]
        public void create_custom_board (Adw.ActionRow source) {
            if (is_infinite_mode) {
                move_count.set_visible (false);
            } else {
                move_count.set_visible (true);
            }

            stack.set_visible_child_name ("custom");
        }

        [GtkCallback]
        public void save_custom_board () {
            Window win = ((Window) this.get_root ());

            custom_listbox.unselect_all ();

            Application.settings.set_int ("difficulty", 3);

            var rowcol = rowcol_count.get_buffer ().get_text ();
            if (rowcol.length == 0 || int.parse(rowcol) >= 20) {
                rowcol_count.add_css_class ("error");
                return;
            }
            Application.settings.set_int ("custom-difficulty-rows-cols", int.parse(rowcol));

            if (!is_infinite_mode) {
                var moves = move_count.get_buffer ().get_text ();
                if (moves.length == 0) {
                    moves = Difficulty.HARD.get_move_limit ().to_string ();
                }
                Application.settings.set_int ("custom-difficulty-moves", int.parse(moves));
            }

            win.start_game ();

            stack.set_visible_child_name ("main");
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
                    Window win = ((Window) this.get_root ());

                    win.start_game ();
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

            Application.settings.changed.connect ((key) => {
                if (key == "infinite-mode" && Application.settings.get_boolean ("infinite-mode") == true) {
                    move_count.set_visible (false);
                }
                if (key == "infinite-mode" && Application.settings.get_boolean ("infinite-mode") == false) {
                    move_count.set_visible (true);
                }
            });
        }
    }
}

