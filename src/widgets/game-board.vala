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
        public Colours colour { get; construct; }
        public int size { get; construct; }
        
        public void reset_colour (Colours colour) {
            for (var i = 0; i < 6; i++) {
                this.get_style_context ().remove_class (Colours.get_for_pos (i).get_style_class ());
            }
            
            this.get_style_context ().add_class (colour.get_style_class ());
            
        }
    
        public Square (Colours colour, int size = 32) {
            Object (
                colour: colour,
                size: size
            );
        }
        
        construct {
            set_size_request (size, size);
            this.get_style_context ().add_class (colour.get_style_class ());
        }
    }

    [GtkTemplate (ui = "/dev/jamiethalacker/window_painter/game-board.ui")]
    public class GameBoard : Gtk.Grid {
        public Difficulty difficulty { get; set; }
        public Colours current_colour { get; set; }

        private int num_rows_cols;
    
        public Gee.List<Square> squares { get; construct; }
        private Gee.List<int> flooded_indices;
    
        public GameBoard () {
            Object ();
        }
        
        construct {
            squares = new Gee.ArrayList<Square> ();
            flooded_indices = new Gee.ArrayList<int> ();
            
            dispose_ui ();
            
            Signals.get_default ().do_button_click.connect ((colour) => {
                flood (colour);
            });

            Signals.get_default ().new_game.connect (() => {
                dispose_ui ();
                initialise ();
                Signals.get_default ().set_current_colour (current_colour);
            });
        }
        
        private void initialise () {
            difficulty = (Difficulty) Application.settings.get_int ("difficulty");

            flooded_indices.clear ();

            num_rows_cols = difficulty.get_num_rows_cols ();
        
            setup_ui ();
            
            current_colour = squares.get (0).colour;
            flooded_indices.add (0);
            update_flooded_indices ();
        }
        
        private void setup_ui () {
            for (int row = 0; row < num_rows_cols; row++) {
                for (int col = 0; col < num_rows_cols; col++) {
                    int index = index_for_coord (row, col);
                    Square square;
                    square = new Square (Colours.get_random (), difficulty.get_square_size ());
                    squares.insert (index, square);
                    this.attach (square, col, row);
                }
            }
        }
        
        private void dispose_ui () {
            foreach (var square in squares) {
                square.unparent ();
                square.dispose ();
            }
        }
        
        public void flood (Colours new_colour) {
            current_colour = new_colour;
            foreach (int index in flooded_indices) {
                squares.get (index).reset_colour (new_colour);
            }
            
            if (update_flooded_indices ()) {
                var win = ((Window)new Utils ().find_ancestor_of_type<Window>(this));
                var dialog = new VictoryDialog ();
                dialog.set_transient_for (win);
                dialog.present ();
                return;
            }
        }
        
        // This is… not ideal… but it works!
        private bool update_flooded_indices () {
            Gee.Set<int> new_indices = new Gee.HashSet<int> ();
            do {
                new_indices.clear ();
                foreach (int index in flooded_indices) {
                    int row = index / num_rows_cols;
                    int col = index % num_rows_cols;
                    // Look up
                    int? north_neighbor_index = index_for_coord (row - 1, col);
                    if (should_flood_neighbor (north_neighbor_index)) {
                        new_indices.add (north_neighbor_index);
                    }
                    // Look left
                    int? west_neighbor_index = index_for_coord (row, col - 1);
                    if (should_flood_neighbor (west_neighbor_index)) {
                        new_indices.add (west_neighbor_index);
                    }
                    // Look down
                    int? south_neighbor_index = index_for_coord (row + 1, col);
                    if (should_flood_neighbor (south_neighbor_index)) {
                        new_indices.add (south_neighbor_index);
                    }
                    // Look right
                    int? east_neighbor_index = index_for_coord (row, col + 1);
                    if (should_flood_neighbor (east_neighbor_index)) {
                        new_indices.add (east_neighbor_index);
                    }
                }
                flooded_indices.add_all (new_indices);
            } while (new_indices.size > 0);
            return flooded_indices.size == (num_rows_cols * num_rows_cols);
        }

        private bool should_flood_neighbor (int? neighbor_index) {
            return neighbor_index != null && !flooded_indices.contains (neighbor_index) && (squares.get (neighbor_index).colour == current_colour);
        }
        
         /*
         * Convert the (row,col) game board coordinates to an index in the squares list
         */
        private int? index_for_coord (int row, int col) {
            if (row < 0 || row >= num_rows_cols || col < 0 || col >= num_rows_cols) {
                return null;
            }
            return col + (row * num_rows_cols);
        }
    }
}
