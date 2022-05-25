/* models/difficulty.vala
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
    public enum Difficulty {
        EASY,
        NORMAL,
        HARD,
        CUSTOM;

        public int get_num_rows_cols () {
            switch (this) {
                case EASY:
                    return 5;
                case NORMAL:
                    return 10;
                case HARD:
                    return 14;
                case CUSTOM:
                    return Application.settings.get_int ("custom-difficulty-rows-cols");
                default:
                    assert_not_reached ();
            }
        }

        public int get_square_size () {
            switch (this) {
                case EASY:
                    return 98;
                case NORMAL:
                    return 49;
                case HARD:
                    return 35;
                case CUSTOM:
                    return 35;
                default:
                    assert_not_reached ();
            }
        }

        public int get_move_limit () {
            switch (this) {
                case EASY:
                    return 15;
                case NORMAL:
                    return 20;
                case HARD:
                    return 25;
                case CUSTOM:
                    return Application.settings.get_int ("custom-difficulty-moves");
                default:
                    assert_not_reached ();
            }

        }
    }
}
