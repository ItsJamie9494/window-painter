/* widgets/colour-switcher.vala
 *
 * Copyright 2022-2024 Jamie Murphy
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

//   TODO: freeze the CSS transition until the initial button was selected

namespace WindowPainter {
    public class ColourSwitcher : Adw.Bin {
        private Gtk.Box box;

        public ColourSwitcher () {
            Object ();
        }

        construct {
            this.set_sensitive (false);

            // Create FlowBox
            box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 8) {
                halign = Gtk.Align.CENTER,
            };

            // Create ShortcutController
            Gtk.ShortcutController controller = new Gtk.ShortcutController ();
            controller.set_scope (Gtk.ShortcutScope.GLOBAL);
            this.add_controller ((Gtk.EventController) controller);

            // Create Buttons
            for (int i = Colours.MESON_RED; i <= Colours.GLUON_BROWN; i++) {
                Gtk.ToggleButton grouping_btn = (Gtk.ToggleButton) box.get_first_child ();
                Gtk.Widget new_btn = (Gtk.Widget) new Gtk.ToggleButton () {
                    height_request = 64,
                    width_request = 64,
                };

                new_btn.set_tooltip_text (((Colours) i).get_tooltip ());
                new_btn.add_css_class (((Colours) i).get_style_class ());
                new_btn.add_css_class ("circular");

                new_btn.set_data<Colours> ("colour", (Colours) i);

                ((Gtk.ToggleButton) new_btn).toggled.connect (toggled_cb);

                if (grouping_btn != null)
                    ((Gtk.ToggleButton) new_btn).set_group (grouping_btn);

                box.append (new_btn);

                // Shortcuts
                Gtk.Shortcut shortcut = new Gtk.Shortcut.with_arguments (new Gtk.KeyvalTrigger (((Colours) i).get_key (), Gdk.ModifierType.NO_MODIFIER_MASK),
                                                                         new Gtk.CallbackAction (shortcut_activated_cb),
                                                                         "i", i);
                controller.add_shortcut (shortcut);
            }

            this.set_child (box);
        }

        private bool shortcut_activated_cb (Gtk.Widget _, Variant? args) {
            Window win = Window.get_default ();
            Application app = (Application) win.get_application ();
            Gtk.Widget widget = this.box.get_first_child ();

            if (!app.game_active)
                return false;

            do {
                Colours btn_colour = widget.get_data ("colour");

                bool active = (Colours) args.get_int32() == btn_colour;
                if (active) {
                    ((Gtk.ToggleButton) widget).set_active (active);
                    return true;
                }
            } while ((widget = widget.get_next_sibling ()) != null);

            return false;
        }

        private void toggled_cb (Gtk.ToggleButton btn) {
            Colours btn_colour = btn.get_data ("colour");
            Window win = (Window) this.get_root ();

            // don't emit anything twice
            if (btn.active != true)
                return;

            win.gameboard.flood (btn_colour);
        }

        public void set_initial_colour (Colours colour) {
            Gtk.Widget widget = this.box.get_first_child ();

            do {
                Colours btn_colour = widget.get_data ("colour");

                ((Gtk.ToggleButton) widget).set_active (colour == btn_colour);
            } while ((widget = widget.get_next_sibling ()) != null);
        }
    }
}