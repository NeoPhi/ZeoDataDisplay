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
     * Stores an date without regard for timezones.
     * This class does no range checking of values.
     */
    public class ZeoDate
    {
        private var _year:int;

        private var _month:int;

        private var _dayOfMonth:int;

        private var _utcDate:Date;

        public function ZeoDate(year:int, month:int, dayOfMonth:int)
        {
            _year = year;
            _month = month;
            _dayOfMonth = dayOfMonth;
            var utc:Number = Date.UTC(year, month, dayOfMonth);
            _utcDate = new Date(utc);
        }

        /**
         * The full year (a four-digit number, such as 2000).
         */
        public function get year():int
        {
            return _year;
        }

        /**
         * The month (0 for January, 1 for February, and so on).
         */
        public function get month():int
        {
            return _month;
        }

        /**
         * The day of the month (an integer from 1 to 31).
         */
        public function get dayOfMonth():int
        {
            return _dayOfMonth;
        }

        /**
         * @inheritDoc
         */
        public function valueOf():Date
        {
            return _utcDate;
        }

        /**
         * Determine if two instances are equal.
         * @param zeoDate Instance to compare to.
         * @return True if the instances are equal.
         */
        public function equals(zeoDate:ZeoDate):Boolean
        {
            return ((getQualifiedClassName(this) == getQualifiedClassName(zeoDate)) && (year == zeoDate.year) && (month == zeoDate.month) &&
                    (dayOfMonth == zeoDate.dayOfMonth));
        }
    }
}