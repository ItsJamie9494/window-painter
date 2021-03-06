/* objects/signals.vala
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

public class Signals : GLib.Object {
    private static Signals _signals;
    public static unowned Signals get_default () {
        if (_signals == null) {
            _signals = new Signals ();
        }

        return _signals;
    }

    public signal void switch_stack (string stack_page);
    public signal void new_game ();
    public signal void set_current_colour (WindowPainter.Colours colour);
    public signal void do_button_click (WindowPainter.Colours colour);
    public signal void update_move_count (int moves_remaining);
}

