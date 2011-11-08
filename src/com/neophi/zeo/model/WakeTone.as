/*
 * Copyright (c) 2010 Daniel Rinehart <danielr@neophi.com> [http://danielr.neophi.com/]
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package com.neophi.zeo.model
{

    /**
     * Indicates the wake tone selected by the user.
     * The documentation used in this class borrows heavily from the
     * "myZeo Export Data Help Sheet" documentation available on myzeo.com.
     */
    public class WakeTone
    {
        /**
         * 0 - Duo
         */
        public static const DUO:WakeTone = new WakeTone();

        /**
         * 1 - Forest
         */
        public static const FOREST:WakeTone = new WakeTone();

        /**
         * 2 - Sunrise
         */
        public static const SUNRISE:WakeTone = new WakeTone();

        /**
         * 3 - Meadow
         */
        public static const MEADOW:WakeTone = new WakeTone();

        /**
         * 4 - Daybreak
         */
        public static const DAYBREAK:WakeTone = new WakeTone();


        private static const VALUE_LOOKUP:Array = [DUO, FOREST, SUNRISE, MEADOW, DAYBREAK];

        /**
         * Return the WakeTone instance corresponding to the value.
         * @param value WakeTone code
         * @return WakeTone instance
         * @throws ArgumentError if the value does not map to a WakeTone instance
         */
        public static function valueOf(value:int):WakeTone
        {
            if ((value < 0) || (value >= VALUE_LOOKUP.length))
            {
                throw new ArgumentError("Value \"" + value + "\" is not a valid WakeTone value.");
            }

            return VALUE_LOOKUP[value];
        }
    }
}