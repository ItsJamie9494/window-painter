/* widgets/colour-switcher.vala
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
    [GtkTemplate (ui = "/dev/jamiethalacker/window_painter/colour-switcher.ui")]
    public class ColourSwitcher : Gtk.Box {
        [GtkCallback]
        public void button_click (Gtk.Button source) {
            var widget = this.get_first_child ();
            for (var i = 0; i < 6; i++) {
                if (widget != null) {
                    widget.set_sensitive (true);
                    widget = widget.get_next_sibling ();
                }
            }

            source.set_sensitive (false);

            for (var i = 0; i < 6; i++) {
                if (source.get_style_context ().has_class (Colours.get_for_pos (i).get_style_class ())) {
                    Signals.get_default ().do_button_click (Colours.get_for_pos (i));
                }
            }
        }
        
        public ColourSwitcher () {
            Object ();
        }

        construct {
            Signals.get_default ().set_current_colour.connect ((colour) => {
                this.set_sensitive (true);
                var widget = this.get_first_child ();
                for (var i = 0; i < 6; i++) {
                    if (widget != null) {
                        if (widget.get_style_context ().has_class (colour.get_style_class ())) {
                            widget.set_sensitive (false);
                        } else {
                            widget.set_sensitive (true);
                        }
                        widget = widget.get_next_sibling ();
                    }
                }
            });

            Signals.get_default ().switch_stack.connect ((stack_page) => {
                if (stack_page == "gameboard") {
                    // do nothing
                } else if (stack_page == "difficulty") {
                    this.set_sensitive (false);
                }
            });
        }
    }
}
