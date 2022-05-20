/* utils.vala
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
    public class Utils {
        public T find_ancestor_of_type<T> (Gtk.Widget? ancestor) {
            while ((ancestor = ancestor.get_parent ()) != null){
                if (ancestor.get_type ().is_a (typeof (T)))
                    return (T) ancestor;
            }

            return null;
        }
    }
}
