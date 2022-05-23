/* dialogs/defeat-dialog.vala
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
    [GtkTemplate (ui = "/dev/jamiethalacker/window_painter/defeat-dialog.ui")]
    public class DefeatDialog : Gtk.Dialog {
        public DefeatDialog () {
            Object ();
        }

        construct {
            this.response.connect ((response_id)=> {
                if (response_id == Gtk.ResponseType.OK) {
                    Signals.get_default ().switch_stack ("difficulty");
                    this.close ();
                }

                if (response_id == Gtk.ResponseType.CANCEL) {
                    if (this.get_transient_for ().get_application () != null) {
                        this.get_transient_for ().get_application ().quit ();
                    }
                }
            });
        }
    }
}
