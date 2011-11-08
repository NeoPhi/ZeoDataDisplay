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
     * Indicates which alarm type is enabled.
     * The documentation used in this class borrows heavily from the
     * "myZeo Export Data Help Sheet" documentation available on myzeo.com.
     */
    public class AlarmType
    {
        /**
         * 0 – standard wake
         */
        public static const STANDARD_WAKE:AlarmType = new AlarmType();

        /**
         * 1 – SmartWake
         */
        public static const SMART_WAKE:AlarmType = new AlarmType();

        private static const VALUE_LOOKUP:Array = [STANDARD_WAKE, SMART_WAKE];

        /**
         * Return the AlarmType instance corresponding to the value.
         * @param value AlarmType code
         * @return AlarmType instance
         * @throws ArgumentError if the value does not map to an AlarmType instance
         */
        public static function valueOf(value:int):AlarmType
        {
            if ((value < 0) || (value >= VALUE_LOOKUP.length))
            {
                throw new ArgumentError("Value \"" + value + "\" is not a valid AlarmType value.");
            }

            return VALUE_LOOKUP[value];
        }
    }
}