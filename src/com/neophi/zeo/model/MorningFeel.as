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
     * Indicates the user's perception of how they slept that night.
     * The documentation used in this class borrows heavily from the
     * "myZeo Export Data Help Sheet" documentation available on myzeo.com.
     */
    public class MorningFeel
    {
        /**
         * 0 - Unknown
         */
        public static const UNKNOWN:MorningFeel = new MorningFeel();

        /**
         * 1 - Terribly
         */
        public static const TERRIBLY:MorningFeel = new MorningFeel();

        /**
         * 2 - Poorly
         */
        public static const POORLY:MorningFeel = new MorningFeel();

        /**
         * 3 - Okay
         */
        public static const OKAY:MorningFeel = new MorningFeel();

        /**
         * 4 - Well
         */
        public static const WELL:MorningFeel = new MorningFeel();

        /**
         * 5 - Great
         */
        public static const GREAT:MorningFeel = new MorningFeel();

        private static const VALUE_LOOKUP:Array = [UNKNOWN, TERRIBLY, POORLY, OKAY, WELL, GREAT];

        /**
         * Return the MorningFeel instance corresponding to the value.
         * @param value MorningFeel code
         * @return MorningFeel instance
         * @throws ArgumentError if the value does not map to a MorningFeel instance
         */
        public static function valueOf(value:int):MorningFeel
        {
            if ((value < 0) || (value >= VALUE_LOOKUP.length))
            {
                throw new ArgumentError("Value \"" + value + "\" is not a valid MorningFeel value.");
            }

            return VALUE_LOOKUP[value];
        }
    }
}