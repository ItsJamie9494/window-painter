/* models/colours.vala
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
    public enum Colours {
        MESON_RED,
        ELECTRON_YELLOW,
        MUON_GREEN,
        PROTON_BLUE,
        TAU_PURPLE,
        FERMION_PINK;
        
        public string get_style_class () {
            switch (this) {
                case MESON_RED:
                    return "meson-red";
                case ELECTRON_YELLOW:
                    return "electron-yellow";
                case MUON_GREEN:
                    return "muon-green";
                case PROTON_BLUE:
                    return "proton-blue";
                case TAU_PURPLE:
                    return "tau-purple";
                case FERMION_PINK:
                    return "fermion-pink";
                default:
                    assert_not_reached ();
            }
        }
        
        public static Colours get_random () {
            return (Colours) GLib.Random.int_range (0, 6);
        }
    }
}
