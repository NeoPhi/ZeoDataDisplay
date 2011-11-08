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
     * Indicates the reason for the most recent alarm ringing.
     * The documentation used in this class borrows heavily from the
     * "myZeo Export Data Help Sheet" documentation available on myzeo.com.
     */
    public class AlarmReason
    {
        /**
         * 0 - REM to NREM Transition
         */
        public static const REM_TO_NREM_TRANSITION:AlarmReason = new AlarmReason();

        /**
         * 1 - NREM to REM Transition
         */
        public static const NREM_TO_REM_TRANSITION:AlarmReason = new AlarmReason();

        /**
         * 2 - Wake while awake
         */
        public static const WAKE_ON_WAKE:AlarmReason = new AlarmReason();

        /**
         * 3 – Prevent waking from Deep sleep
         */
        public static const DEEP_RISING:AlarmReason = new AlarmReason();

        /**
         * 4 - End of Wake Window
         */
        public static const END_OF_WAKE_WINDOW:AlarmReason = new AlarmReason();

        /**
         * 5 - NoAlarm
         */
        public static const NO_ALARM:AlarmReason = new AlarmReason();

        private static const VALUE_LOOKUP:Array =
                [REM_TO_NREM_TRANSITION, NREM_TO_REM_TRANSITION, WAKE_ON_WAKE, DEEP_RISING, END_OF_WAKE_WINDOW, NO_ALARM];

        /**
         * Return the AlarmReason instance corresponding to the value.
         * @param value AlarmReason code
         * @return AlarmReason instance
         * @throws ArgumentError if the value does not map to an AlarmReason instance
         */
        public static function valueOf(value:int):AlarmReason
        {
            if ((value < 0) || (value >= VALUE_LOOKUP.length))
            {
                throw new ArgumentError("Value \"" + value + "\" is not a valid AlarmReason value.");
            }

            return VALUE_LOOKUP[value];
        }
    }
}