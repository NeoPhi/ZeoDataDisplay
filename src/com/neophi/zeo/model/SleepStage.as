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
     * Sleep stage encoding.
     * The documentation used in this class borrows heavily from the
     * "myZeo Export Data Help Sheet" documentation available on myzeo.com.
     */
    public class SleepStage
    {
        /**
         * 0 - undefined
         */
        public static const UNDEFINED:SleepStage = new SleepStage(0);

        /**
         * 1 - Wake
         */
        public static const WAKE:SleepStage = new SleepStage(1);

        /**
         * 2 - REM
         */
        public static const REM:SleepStage = new SleepStage(2);

        /**
         * 3 - Light
         */
        public static const LIGHT:SleepStage = new SleepStage(3);

        /**
         * 4 - Deep
         */
        public static const DEEP:SleepStage = new SleepStage(4);

        /**
         * 5 - Unused
         */
        public static const UNUSED:SleepStage = new SleepStage(5);

        /**
         * 6 - Deep 2
         */
        public static const DEEP_2:SleepStage = new SleepStage(6);

        private static const VALUE_LOOKUP:Array = [UNDEFINED, WAKE, REM, LIGHT, DEEP, UNUSED, DEEP_2];

        /**
         * Return the SleepStage instance corresponding to the value.
         * @param value SleepStage code
         * @return SleepStage instance
         * @throws ArgumentError if the value does not map to a SleepStage instance
         */
        public static function valueOf(value:int):SleepStage
        {
            if ((value < 0) || (value >= VALUE_LOOKUP.length))
            {
                throw new ArgumentError("Value \"" + value + "\" is not a valid SleepStage value.");
            }

            return VALUE_LOOKUP[value];
        }

        private var _value:int;

        /**
         * Define a new sleep stage.
         * @param value A numerical value for the sleep stage
         */
        public function SleepStage(value:int)
        {
            _value = value;
        }

        /**
         * Returns the numerical value for the sleep stage.
         * @return Numerical value
         */
        public function get value():int
        {
            return _value;
        }

        /**
         * Does this sleep stage represent that the user is sleeping?
         * @return True if the user is sleeping at this stage
         */
        public function isSleep():Boolean
        {
            return ((this == REM) || (this == LIGHT) || (this == DEEP) || (this == DEEP_2));
        }

        /**
         * Does this sleep stage represent that the user is awake?
         * @return True if the user is awake at this stage
         */
        public function isWake():Boolean
        {
            return (this == WAKE);
        }

        /**
         * Does this sleep stage represent that the sleep stage was unknown.
         * @return  True if the sleep stage is unknown
         */
        public function isUnknown():Boolean
        {
            return ((this == UNDEFINED) || (this == UNUSED));
        }
    }
}