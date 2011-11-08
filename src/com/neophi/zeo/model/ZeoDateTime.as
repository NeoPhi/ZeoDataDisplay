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
    import flash.utils.getQualifiedClassName;

    /**
     * Stores a date and time without regard for timezones.
     * This class does no range checking of values.
     */
    public class ZeoDateTime
    {
        /**
         * The month (0 for January, 1 for February, and so on).
         */
        public var month:int;

        /**
         * The day of the month (an integer from 1 to 31).
         */
        public var dayOfMonth:int;

        /**
         * The full year (a four-digit number, such as 2000).
         */
        public var year:int;

        /**
         * The hour (an integer from 0 to 23) of the day.
         */
        public var hour:int;

        /**
         * The minutes (an integer from 0 to 59) of the hour.
         */
        public var minute:int;

        /**
         * Determine if two instances are equal.
         * @param zeoDate Instance to compare to.
         * @return True if the instances are equal.
         */
        public function equals(zeoDateTime:ZeoDateTime):Boolean
        {
            return ((getQualifiedClassName(this) == getQualifiedClassName(zeoDateTime)) && (year == zeoDateTime.year) &&
                    (month == zeoDateTime.month) && (dayOfMonth == zeoDateTime.dayOfMonth) && (hour == zeoDateTime.hour) &&
                    (minute == zeoDateTime.minute));
        }
    }
}