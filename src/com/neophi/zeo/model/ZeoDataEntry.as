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
     * Each row represents a single night of sleep in the CSV file. Each row is converted into a
     * ZeoData record which captures that row's data.
     * The documentation used in this class borrows heavily from the
     * "myZeo Export Data Help Sheet" documentation available on myzeo.com.
     */
    public class ZeoDataEntry
    {
        /**
         * Sleep records are assigned to a “sleep date” according to the time they started. If a sleep record starts before 6am, it is assigned the sleep date of the previous day. I.e. A sleep record that starts at 4:00 am 5/15/2009 will be assigned a sleep date of 5/14/2009.
         * Only one sleep record is stored per 24-hour period. If there are multiple sleep records for a 24-hour period, the longest period is selected.
         * Sleep records that have been marked as “Incomplete Data” (25% or more of the night cannot be recognized) are not stored.
         */
        public var sleepDate:ZeoDate;

        /**
         * Summarizes how you slept in a single, objective number. ZQ is based on the length, depth, and continuity of your sleep. There is no optimal ZQ for everyone, but you can use it to gauge how you sleep each night.
         */
        public var zq:int;

        /**
         * How long you actually slept during the night.
         */
        public var totalZ:int;

        /**
         * How long it actually took you to fall asleep. This is the time from when you put your headband on till when you fell asleep and stayed asleep.
         */
        public var timeToZ:int;

        /**
         * From the moment you fall asleep until you wake up, this is the length of time you were awake when you should have been sleeping.
         */
        public var timeInWake:int;

        /**
         * A phase of sleep important for its contribution to overall mental health, mood, and ability to learn and retain knowledge.
         */
        public var timeInREM:int;

        /**
         * The phase of sleep that typically accounts for the majority of a night of sleep.
         */
        public var timeInLight:int;

        /**
         * A phase of sleep important for feeling restored and refreshed, as well as for growth and immunity.
         */
        public var timeInDeep:int;

        /**
         * The number of times you woke up in the middle of the night. A wake-up is defined as a disruption that lasts 2 minutes or more. You may not remember all the times that you woke during the night.
         */
        public var awakenings:int;

        /**
         * The date and time corresponding to the first moment in a night of sleep is recorded. This time is always aligned to a 5-minute boundary.
         */
        public var startOfNight:ZeoDateTime;

        /**
         * The date and time at which no further sleep data was collected for that night.
         */
        public var endOfNight:ZeoDateTime;

        /**
         * The date and time the user awoke. This is computed as "the time of day at the end of the last 5 minute block of sleep in the sleep graph." If no sleep is present in the sleep graph, the value is null.
         */
        public var riseTime:ZeoDateTime;

        /**
         * Indicates the reason for the most recent alarm ringing.
         * @see AlarmReason
         */
        public var alarmReason:AlarmReason;

        /**
         * Number of minutes for snooze time, as set by the user.
         */
        public var snoozeTime:int;

        /**
         * Indicates the wake tone selected by the user.
         * @see WakeTone
         */
        public var wakeTone:WakeTone;

        /**
         * Indicates the wake up window as selected by the user. The value ranges from 15 to 40 minutes in 5-minute increments.
         */
        public var wakeWindow:int;

        /**
         * Indicates which alarm type is enabled.
         * @see AlarmType
         */
        public var alarmType:AlarmType;

        /**
         * The time the alarm first rang during a night, regardless of alarm type.
         */
        public var firstAlarmRing:ZeoDateTime;

        /**
         * The final time the alarm rang during a night. The alarm ring could be caused by SmartWake, standard wake or the snooze.
         */
        public var lastAlarmRing:ZeoDateTime;

        /**
         * The first time the snooze button was pressed during the night. If the snooze button is pressed more than 9 times, this value will indicate the times of the 9 latest, rather than the 9 earliest presses.
         */
        public var firstSnoozeTime:ZeoDateTime;

        /**
         * The final time the snooze button was pressed during the night.
         */
        public var lastSnoozeTime:ZeoDateTime;

        /**
         * The time of the alarm as set by the user. Null if not activated. If the alarm time changed during the night, this indicates the most recent value.
         */
        public var setAlarmTime:ZeoDateTime;

        /**
         * Indicates the userʼs perception of how they slept that night. Null indicates they entered no rating.
         * Value can be entered on the bedside display or in the journal. The most recent value entered is stored.
         */
        public var morningFeel:MorningFeel;

        /**
         * How did you feel today?
         * Irritable (1) -> Easygoing (5).
         */
        public var dayFeel1:Integer;

        /**
         * How did you feel today?
         * Unfocused (1) -> Focused (5).
         */
        public var dayFeel2:Integer;

        /**
         * How did you feel today?
         * Tired (1) -> Energetic (5).
         */
        public var dayFeel3:Integer;

        /**
         * Notes that the user wrote in the Sleep Journal.
         */
        public var notes:String;

        /**
         * The items in this property describe entries you made in the Sleep Journal relating to Sleep Stealers.
         */
        public var sleepStealers:SleepStealers = new SleepStealers();

        /**
         * A 5-minute sleep graph containing a space-separated list of numbers. Each number represents a 5-minute time period (ex. a 6-hour sleep graph would have 72 integers). The sleep stages are encoded as:
         * @see SleepStage
         */
        public var sleepGraph:Vector.<SleepStage> = new Vector.<SleepStage>();

        /**
         * A 30-second sleep graph containing a space-separated list of numbers. Each number represents a 30-second time period. The sleep stages are encoded as:
         * @see SleepStage
         */
        public var detailedSleepGraph:Vector.<SleepStage> = new Vector.<SleepStage>();

        /**
         * Zeo Bedside Display software version.
         */
        public var firmwareVersion:String;

        /**
         * myZeo website software version.
         */
        public var myZeoVersion:String;
    }
}