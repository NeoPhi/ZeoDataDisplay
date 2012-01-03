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
package com.neophi.zeo.parser
{
    import com.neophi.error.ErrorEventChain;
    import com.neophi.parser.ICSVParser;
    import com.neophi.zeo.model.AlarmReason;
    import com.neophi.zeo.model.AlarmType;
    import com.neophi.zeo.model.Integer;
    import com.neophi.zeo.model.MorningFeel;
    import com.neophi.zeo.model.SleepStage;
    import com.neophi.zeo.model.WakeTone;
    import com.neophi.zeo.model.ZeoDataEntry;
    import com.neophi.zeo.model.ZeoDate;
    import com.neophi.zeo.model.ZeoDateTime;

    import flash.display.Shape;
    import flash.events.ErrorEvent;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.ProgressEvent;

    [Event(name="error", type="flash.events.ErrorEvent")]
    [Event(name="complete", type="flash.events.Event")]
    [Event(name="progress", type="flash.events.ProgressEvent")]
    /**
     * Utility class for parsing a CSV file containing sleep data as exported from the myZeo website.
     */
    public class ZeoCSVParser extends EventDispatcher
    {

        /**
         * Ordered list of the columns that appear in the CSV file.
         */
        private static const COLUMNS:Vector.<ColumnHandler> = Vector.<ColumnHandler>([new ColumnHandler("Sleep Date", "sleepDate", parseDate),
                new ColumnHandler("ZQ", "zq", parseInteger, 0),
                new ColumnHandler("Total Z", "totalZ", parseInteger, 0),
                new ColumnHandler("Time to Z", "timeToZ", parseInteger, 0),
                new ColumnHandler("Time in Wake", "timeInWake", parseInteger, 0),
                new ColumnHandler("Time in REM", "timeInREM", parseInteger, 0),
                new ColumnHandler("Time in Light", "timeInLight", parseInteger, 0),
                new ColumnHandler("Time in Deep", "timeInDeep", parseInteger, 0),
                new ColumnHandler("Awakenings", "awakenings", parseInteger, 0),
                new ColumnHandler("Start of Night", "startOfNight", parseDateTime),
                new ColumnHandler("End of Night", "endOfNight", parseDateTime),
                new ColumnHandler("Rise Time", "riseTime", parseDateTime),
                new ColumnHandler("Alarm Reason", "alarmReason", parseEnum, AlarmReason),
                new ColumnHandler("Snooze Time", "snoozeTime", parseInteger, 0, 30),
                new ColumnHandler("Wake Tone", "wakeTone", parseEnum, WakeTone),
                new ColumnHandler("Wake Window", "wakeWindow", parseInteger, 15, 40, 5, 0),
                new ColumnHandler("Alarm Type", "alarmType", parseEnum, AlarmType),
                new ColumnHandler("First Alarm Ring", "firstAlarmRing", parseDateTime),
                new ColumnHandler("Last Alarm Ring", "lastAlarmRing", parseDateTime),
                new ColumnHandler("First Snooze Time", "firstSnoozeTime", parseDateTime),
                new ColumnHandler("Last Snooze Time", "lastSnoozeTime", parseDateTime),
                new ColumnHandler("Set Alarm Time", "setAlarmTime", parseDateTime),
                new ColumnHandler("Morning Feel", "morningFeel", parseEnum, MorningFeel),
                new ColumnHandler("Day Feel 1", "dayFeel1", parseInteger, 1, 5),
                new ColumnHandler("Day Feel 2", "dayFeel2", parseInteger, 1, 5),
                new ColumnHandler("Day Feel 3", "dayFeel3", parseInteger, 1, 5),
                new ColumnHandler("Notes", "notes", parseString),
                new ColumnHandler("SS Fall Asleep", "sleepStealers.fallAsleep", parseInteger, 0, 3),
                new ColumnHandler("SS Anticipation", "sleepStealers.anticipation", parseInteger, 0, 3),
                new ColumnHandler("SS Tension", "sleepStealers.tension", parseInteger, 0, 3),
                new ColumnHandler("SS Comfort", "sleepStealers.comfort", parseInteger, 0, 3),
                new ColumnHandler("SS Noise", "sleepStealers.noise", parseInteger, 0, 3),
                new ColumnHandler("SS Light", "sleepStealers.light", parseInteger, 0, 3),
                new ColumnHandler("SS Temperature", "sleepStealers.temperature", parseInteger, 0, 3),
                new ColumnHandler("SS Familiar", "sleepStealers.familiar", parseInteger, 0, 3),
                new ColumnHandler("SS Bedroom", "sleepStealers.bedroom", parseInteger, 0, 3),
                new ColumnHandler("SS Disruption", "sleepStealers.disruption", parseInteger, 0, 3),
                new ColumnHandler("SS Hot Flashes", "sleepStealers.hotFlashes", parseInteger, 0, 3),
                new ColumnHandler("SS Dreams", "sleepStealers.dreams", parseInteger, 0, 3),
                new ColumnHandler("SS Fullness", "sleepStealers.fullness", parseInteger, 0, 3),
                new ColumnHandler("SS Hunger", "sleepStealers.hunger", parseInteger, 0, 3),
                new ColumnHandler("SS Heartburn", "sleepStealers.heartburn", parseInteger, 0, 3),
                // Little odd that caffeine is 0-5 while all others are 0-3
                new ColumnHandler("SS Caffeine", "sleepStealers.caffeine", parseInteger, 0, 5),
                // Sample data from a user indicated that Alcohol can also be outside 0-3, assuming it is also 0-5
                new ColumnHandler("SS Alcohol", "sleepStealers.alcohol", parseInteger, 0, 5),
                new ColumnHandler("SS Thirst", "sleepStealers.thirst", parseInteger, 0, 3),
                new ColumnHandler("SS Restroom", "sleepStealers.restroom", parseInteger, 0, 3),
                new ColumnHandler("SS Wind Down", "sleepStealers.windDown", parseInteger, 0, 3),
                new ColumnHandler("SS Sleepiness", "sleepStealers.sleepiness", parseInteger, 0, 3),
                new ColumnHandler("SS Exercise", "sleepStealers.exercise", parseInteger, 0, 3),
                new ColumnHandler("SS Time Before Bed", "sleepStealers.timeBeforeBed", parseInteger, 0, 3),
                new ColumnHandler("SS Conversations", "sleepStealers.conversations", parseInteger, 0, 3),
                new ColumnHandler("SS Activity Level", "sleepStealers.activityLevel", parseInteger, 0, 3),
                new ColumnHandler("SS Late Work", "sleepStealers.lateWork", parseInteger, 0, 3),
                new ColumnHandler("SSCF 1", "sleepStealers.customField1", parseInteger, 0, 3),
                new ColumnHandler("SSCF 2", "sleepStealers.customField2", parseInteger, 0, 3),
                new ColumnHandler("SSCF 3", "sleepStealers.customField3", parseInteger, 0, 3),
                new ColumnHandler("SSCF 4", "sleepStealers.customField4", parseInteger, 0, 3),
                new ColumnHandler("SSCF 5", "sleepStealers.customField5", parseInteger, 0, 3),
                new ColumnHandler("SSCF 6", "sleepStealers.customField6", parseInteger, 0, 3),
                new ColumnHandler("SSCF 7", "sleepStealers.customField7", parseInteger, 0, 3),
                new ColumnHandler("SSCF 8", "sleepStealers.customField8", parseInteger, 0, 3),
                new ColumnHandler("SSCF 9", "sleepStealers.customField9", parseInteger, 0, 3),
                new ColumnHandler("SSCF 10", "sleepStealers.customField10", parseInteger, 0, 3),
                new ColumnHandler("SSCF 11", "sleepStealers.customField11", parseInteger, 0, 3),
                new ColumnHandler("SSCF 12", "sleepStealers.customField12", parseInteger, 0, 3),
                new ColumnHandler("SSCF 13", "sleepStealers.customField13", parseInteger, 0, 3),
                new ColumnHandler("SSCF 14", "sleepStealers.customField14", parseInteger, 0, 3),
                new ColumnHandler("SSCF 15", "sleepStealers.customField15", parseInteger, 0, 3),
                new ColumnHandler("SSCF 16", "sleepStealers.customField16", parseInteger, 0, 3),
                new ColumnHandler("SSCF 17", "sleepStealers.customField17", parseInteger, 0, 3),
                new ColumnHandler("SSCF 18", "sleepStealers.customField18", parseInteger, 0, 3),
                new ColumnHandler("SSCF 19", "sleepStealers.customField19", parseInteger, 0, 3),
                new ColumnHandler("SSCF 20", "sleepStealers.customField20", parseInteger, 0, 3),
                new ColumnHandler("SSCF 21", "sleepStealers.customField21", parseInteger, 0, 3),
                new ColumnHandler("Sleep Graph", "sleepGraph", parseSleepGraph),
                new ColumnHandler("Detailed Sleep Graph", "detailedSleepGraph", parseSleepGraph),
                new ColumnHandler("Firmware Version", "firmwareVersion", parseString),
                new ColumnHandler("MyZeo Version", "myZeoVersion", parseString)]);

        private static const SHAPE:Shape = new Shape();

        /**
         * Parse a date field in the format "MM/DD/YYYY" to a Date object.
         * This method treats the incoming date in UTC time and returns
         * a localized Date instance.
         * @param value String to parse
         * @return Localized Date
         */
        private static function parseDate(value:String):ZeoDate
        {
            var dateParts:Array = value.split(/\//);

            if (dateParts.length != 3)
            {
                throw new ArgumentError("Issue parsing date \"" + value + "\".");
            }

            return new ZeoDate(dateParts[2], dateParts[0] - 1, dateParts[1]);
        }

        /**
         * Parse a date and time field in the format "MM/DD/YYYY HH:MM" to a Date object.
         * This method treats the incoming date in UTC time and returns
         * a localized Date instance.
         * @param value String to parse
         * @return Localized Date
         */
        private static function parseDateTime(value:String):ZeoDateTime
        {
            var dateTimeParts:Array = value.split(/\s/);

            if (dateTimeParts.length != 2)
            {
                throw new ArgumentError("Issue parsing date and time \"" + value + "\".");
            }

            var dateParts:Array = dateTimeParts[0].split(/\//);

            if (dateParts.length != 3)
            {
                throw new ArgumentError("Issue parsing date and time \"" + value + "\".");
            }

            var timeParts:Array = dateTimeParts[1].split(/:/);

            if (timeParts.length != 2)
            {
                throw new ArgumentError("Issue parsing date and time \"" + value + "\".");
            }

            var zeoDateTime:ZeoDateTime = new ZeoDateTime();
            zeoDateTime.month = dateParts[0] - 1;
            zeoDateTime.dayOfMonth = dateParts[1];
            zeoDateTime.year = dateParts[2];

            zeoDateTime.hour = timeParts[0];
            zeoDateTime.minute = timeParts[1];

            return zeoDateTime;
        }

        /**
         * Parse a column which represents a value from an enumeration class.
         * @param value String to parse
         * @param enum Enumeration class the value is from
         * @return Enumeration constant for the value
         */
        private static function parseEnum(value:String, enum:Class):Object
        {
            return enum["valueOf"](int(value));
        }

        /**
         * Parse a column which represents an integer.
         * @param value String to parse
         * @param min Minimum value the integer may have
         * @param max Maximum value the integer may have
         * @param modulo Modulo the value must have
         * @param optionalValues Other values that are acceptable, ignoring min, max, and modulo
         * @return Value
         */
        private static function parseInteger(value:String, min:int = int.MIN_VALUE, max:int = int.MAX_VALUE, modulo:int = 1, ... optionalValues):Integer
        {
            var result:int = int(value);

            for each (var optionalValue:int in optionalValues) {
                if (optionalValue == result) {
                    return new Integer(result);
                }
            }
            
            if (result < min)
            {
                throw new ArgumentError("Value \"" + value + "\" is less than \"" + min + "\".");
            }

            if (result > max)
            {
                throw new ArgumentError("Value \"" + value + "\" is greater than \"" + max + "\".");
            }

            if ((result % modulo) != 0)
            {
                throw new ArgumentError("Value \"" + value + "\" is not a modulo of \"" + modulo + "\".");
            }

            return new Integer(result);
        }

        /**
         * Parse a column which represents a sleep graph.
         * @param value String to parse
         * @return Sleep graph data
         */
        private static function parseSleepGraph(value:String):Vector.<SleepStage>
        {
            var sleepGraph:Vector.<SleepStage> = new Vector.<SleepStage>();
            var values:Array = value.split(/\s/);

            for each (var sleepGraphValue:String in values)
            {
                sleepGraph.push(parseEnum(sleepGraphValue, SleepStage));
            }

            return sleepGraph;
        }

        /**
         * Removes all white space from a string and converts null to an empty string.
         * @param value Value to parse
         * @return Parsed string
         */
        private static function parseString(value:String):String
        {
            return trim(value);
        }

        /**
         * Remove all leading and trailing white space from a string.
         * @param string String to trim
         * @return String will all leading and trailing white space removed, maybe the empty string, never null
         */
        private static function trim(string:String):String
        {
            if (string == null)
            {
                return "";
            }
            return string.replace(/^\s*/, "").replace(/\s*$/, "");
        }

        public var result:Vector.<ZeoDataEntry>;

        private var _result:Vector.<ZeoDataEntry>;

        private var _csvParser:ICSVParser;

        private var _recordsPerFrame:int;

        private var _recordCount:int;

        /**
         * Parse a CSV file into a vector of ZeoData instances.
         * Large files may take considerable time to parse. To keep the UI responsive, the recordsPerFrame parameter can
         * be used to control how many records are parsed per frame. When used progress events will be emitted.
         * @param csvParser CSV file to parse
         * @param linesPerFrame How many input lines to parse per cycle, or -1 to parse all at once
         */
        public function parse(csvParser:ICSVParser, recordsPerFrame:int = 10):void
        {
            _result = new Vector.<ZeoDataEntry>();
            _csvParser = csvParser;
            _recordsPerFrame = recordsPerFrame;
            _recordCount = 0;
            parseNextBlock();
        }

        private function parseNextBlock(event:Event = null):void
        {
            SHAPE.removeEventListener(Event.ENTER_FRAME, parseNextBlock);

            var recordsThisFrame:int = 0;

            while ((!_csvParser.complete) && ((_recordsPerFrame == -1) || (recordsThisFrame < _recordsPerFrame)))
            {
                var record:Vector.<String>;

                try
                {
                    record = _csvParser.nextRecord();
                }
                catch (error:Error)
                {
                    dispatchEvent(new ErrorEventChain(ErrorEvent.ERROR, false, false, "Error parsing record " + (_recordCount + 1) + ".", 0, error));
                    return;
                }

                if (record.length == 0)
                {
                    continue;
                }

                if (record.length != COLUMNS.length)
                {
                    dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false,
                            "Record " + (_recordCount + 1) + " had " + record.length + " fields instead of " + COLUMNS.length + ".", 0));
                    return;
                }

                try
                {
                    if (_recordCount == 0)
                    {
                        verifyHeader(record);
                    }
                    else
                    {
                        _result.push(parseColumns(record));
                    }
                }
                catch (error:Error)
                {
                    dispatchEvent(new ErrorEventChain(ErrorEvent.ERROR, false, false, "Error parsing record " + (_recordCount + 1) + ".", 0, error));
                    return;
                }

                _recordCount++;
                recordsThisFrame++;
            }

            if (_csvParser.complete)
            {
                result = _result;
                dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, _csvParser.totalBytes, _csvParser.totalBytes));
                dispatchEvent(new Event(Event.COMPLETE));
            }
            else
            {
                SHAPE.addEventListener(Event.ENTER_FRAME, parseNextBlock);
                dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, _csvParser.processedBytes, _csvParser.totalBytes));
            }
        }

        /**
         * Verify that CSV file has the same header at the one we are expecting.
         * @param columns Parsed header columns
         */
        private function verifyHeader(record:Vector.<String>):void
        {
            for (var i:int = 0; i < COLUMNS.length; i++)
            {
                COLUMNS[i].verifyNameMatches(record[i]);
            }
        }

        /**
         * Create a ZeoData instance based on the column data.
         * @param columns Column data to examine
         * @return ZeoData instance
         */
        private function parseColumns(record:Vector.<String>):ZeoDataEntry
        {
            var zeoData:ZeoDataEntry = new ZeoDataEntry();

            for (var i:int = 0; i < COLUMNS.length; i++)
            {
                if ((record[i] != null) && (record[i] != ""))
                {
                    COLUMNS[i].setProperty(zeoData, record[i]);
                }
            }

            return zeoData;
        }

        /**
         * Array map function to remove leading and trailing double quotes from a string.
         * @param value Value to filter
         * @param index Array index
         * @param array Source array
         * @return String with quotes removed
         */
        private function filterQuotes(value:String, index:int, array:Array):String
        {
            if ((value.length > 0) && (value.charAt(0) == "\"") && (value.charAt(value.length - 1) == "\""))
            {
                if (value.length == 2)
                {
                    return "";
                }
                return value.substring(1, value.length - 1);
            }
            return value;
        }
    }
}
