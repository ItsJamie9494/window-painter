/* widgets/game-board.vala
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
    public class Square : Adw.Bin {
        public string colour { get; construct; }
        public int size { get; construct; }
    
        public Square (Colours colour, int size = 32) {
            Object (
                colour: colour.get_style_class (),
                size: size
            );
        }
        
        construct {
            set_size_request (size, size);
            this.get_style_context ().add_class (colour);
        }
    }

    [GtkTemplate (ui = "/dev/jamiethalacker/window_painter/game-board.ui")]
    public class GameBoard : Gtk.Grid {
        public Gee.List<Square> squares { get; construct; }
    
        public GameBoard () {
            Object ();
        }
        
        construct {
            squares = new Gee.ArrayList<Square> ();
            
            dispose_ui ();
            setup_ui ();
        }
        
        private void setup_ui () {
            for (int row = 0; row < 10; row++) {
                for (int col = 0; col < 10; col++) {
                    int index = index_for_coord (row, col);
                    Square square;
                    square = new Square (Colours.get_random (), 32);
                    squares.insert (index, square);
                    this.attach (square, col, row);
                }
            }
        }
        
        private void dispose_ui () {
            foreach (var square in squares) {
                square.dispose ();
            }
        }
        
         /*
         * Convert the (row,col) game board coordinates to an index in the squares list
         */
        private int? index_for_coord (int row, int col) {
            if (row < 0 || row >= 10 || col < 0 || col >= 10) {
                return null;
            }
            return col + (row * 10);
        }
    }
}
