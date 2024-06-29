/* window.vala
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
    [GtkTemplate (ui = "/dev/jamiethalacker/window_painter/window.ui")]
    public class Window : Adw.ApplicationWindow {
        private static Window _window;
        public static unowned Window get_default () {
            return _window;
        }

        [GtkChild]
        private unowned Adw.ToastOverlay toast_overlay;
        [GtkChild]
        private unowned Gtk.Stack stack;
        [GtkChild]
        private unowned Gtk.Box moves_remaining_container;
        [GtkChild]
        private unowned Gtk.Label moves_remaining_count;
        [GtkChild]
        private unowned Adw.AlertDialog finish_dialog;

        public Window (Application app) {
            Object (application: app);

            if (_window == null) {
                _window = this;
            }

            Signals.get_default ().switch_stack.connect ((stack_page) => {
                stack.set_visible_child_name (stack_page);
            });

            Signals.get_default ().update_move_count.connect ((moves_remaining) => {
                if (moves_remaining_container.get_visible () != true && !Application.settings.get_boolean ("infinite-mode")) {
                    moves_remaining_container.set_visible (true);
                }
                moves_remaining_count.set_label (moves_remaining.to_string ());
            });

            Application.settings.changed.connect ((key) => {
                if (key == "infinite-mode" && Application.settings.get_boolean ("infinite-mode") == true) {
                    if (app.game_active == true) {
                        hide_moves_container ();
                        Signals.get_default ().new_game ();
                    }
                    var toast = new Adw.Toast (_("Infinite Mode Enabled!"));
                    toast.set_timeout (1);
                    toast_overlay.add_toast (toast);
                }
                if (key == "infinite-mode" && Application.settings.get_boolean ("infinite-mode") == false) {
                    if (app.game_active == true) {
                        Signals.get_default ().new_game ();
                    }
                }
            });
        }

        public void hide_moves_container () {
            moves_remaining_container.set_visible (false);
        }

        // Ends the game
        public void end_game (bool did_win) {
            if (did_win) {
                this.finish_dialog.heading = _("🎉️ You Win!");
            } else {
                this.finish_dialog.heading = _("You Lose");
            }

            this.finish_dialog.present (this);
            ((Application) this.get_application ()).game_active = false;
        }

        [GtkCallback]
        private void dialog_response_cb (string response) {
            switch (response) {
                case "playagain":
                    Signals.get_default ().switch_stack ("difficulty");
                    this.finish_dialog.close ();
                    break;
                case "quit":
                    this.get_application ().quit ();
                    break;
                default:
                    // Ignore
                    print ("Unknown Response");
                    break;
            }
        }
    }
}
