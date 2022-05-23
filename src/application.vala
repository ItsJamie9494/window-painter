/* application.vala
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
    public class Application : Adw.Application {
        public static Settings settings;

        private const OptionEntry[] options = {
            { "difficulty", 'd', 0, OptionArg.INT, out difficulty,
              "Set difficulty", "DIFFICULTY (1, 2, 3)"},
            { null }
        };

        public static int difficulty;
        public static bool infinite_mode;

        private const ActionEntry[] action_entries = {
            { "infinite-mode", null, null, "false", infinite_mode_toggle },
            { "about", on_about_action },
            { "new-game", on_new_game },
            { "quit", quit }
        };

        public Application () {
            Object (application_id: "dev.jamiethalacker.window_painter", flags: ApplicationFlags.FLAGS_NONE);
        }

        construct {
            settings = new GLib.Settings ("dev.jamiethalacker.window_painter");
            this.add_main_option_entries (options);
            this.add_action_entries (action_entries, this);
            this.set_accels_for_action ("app.quit", {"<primary>q"});
        }
        
        protected override void startup () {
            resource_base_path = "/dev/jamiethalacker/window_painter";

            base.startup ();
            
            typeof (ColourSwitcher).ensure ();
            typeof (GameBoard).ensure ();
            typeof (DifficultySelector).ensure ();
            
            var provider = new Gtk.CssProvider ();
            provider.load_from_resource ("/dev/jamiethalacker/window_painter/colours.css");
            Gtk.StyleContext.add_provider_for_display (
                Gdk.Display.get_default (),
                provider,
                Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
            );
        }

        public override void activate () {
            base.activate ();
            var win = this.active_window;
            if (win == null) {
                win = new WindowPainter.Window (this);
            }

            if (difficulty > 3 || difficulty < 0) {
                warning ("Difficulty value %i does not exist.\nPermitted values: 1, 2, 3".printf (difficulty));
            } else if (difficulty != 0 && !(difficulty > 3)  && !(difficulty < 0)) {
                if (settings.set_int ("difficulty", difficulty - 1) == true) {
                    Signals.get_default ().switch_stack ("gameboard");
                    Signals.get_default ().new_game ();
                }
            }

            infinite_mode = settings.get_boolean ("infinite-mode");

            // If Infinite Mode is set to false already, this will activate it lol
            if (this.lookup_action ("infinite-mode") != null && infinite_mode != false) {
                this.lookup_action ("infinite-mode").change_state (new Variant.boolean (infinite_mode));
            }

            win.present ();
        }

        private void on_about_action () {
            string[] authors = { "Jamie Murphy" };
            Gtk.show_about_dialog (this.active_window,
                                   "program-name", "Window Painter",
                                   "authors", authors,
                                   "comments", "Fill the board with the same colour of paint",
                                   "copyright", "Made with <3 by Jamie Murphy",
                                   "logo-icon-name", "dev.jamiethalacker.window_painter",
                                   "website", "https://jamiethalacker.dev",
                                   "website-label", "My Personal Website",
                                   "license-type", Gtk.License.GPL_3_0,
                                   "version", "0.1.0");
        }

        private void on_new_game () {
            Signals.get_default ().switch_stack ("difficulty");
        }

        private void infinite_mode_toggle (SimpleAction action, Variant? parameter) {
            if (!action.state.is_of_type (VariantType.BOOLEAN)) {
                warning ("State is not boolean");
            } else {
                var state = action.state.get_boolean ();
                infinite_mode = !state; // Set infinite mode to opposite of state
                action.set_state (infinite_mode);
                settings.set_boolean ("infinite-mode", infinite_mode);
            }
        }
    }
}

int main (string[] args) {
    var app = new WindowPainter.Application ();
    return app.run (args);
}
