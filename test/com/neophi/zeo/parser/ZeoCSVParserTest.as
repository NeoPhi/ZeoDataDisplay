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
    import com.neophi.parser.CSVParser;
    import com.neophi.test.ExternalFilesLoader;
    import com.neophi.zeo.model.AlarmReason;
    import com.neophi.zeo.model.AlarmType;
    import com.neophi.zeo.model.MorningFeel;
    import com.neophi.zeo.model.SleepStage;
    import com.neophi.zeo.model.WakeTone;
    import com.neophi.zeo.model.ZeoDataEntry;
    import com.neophi.zeo.model.ZeoDateMother;
    import com.neophi.zeo.model.ZeoDateTimeMother;
    
    import flash.events.ErrorEvent;
    import flash.events.Event;
    import flash.events.ProgressEvent;
    
    import org.flexunit.asserts.assertEquals;
    import org.flexunit.asserts.assertNotNull;
    import org.flexunit.asserts.assertNull;
    import org.flexunit.asserts.assertTrue;
    import org.flexunit.asserts.fail;
    import org.flexunit.async.Async;
    
    public class ZeoCSVParserTest
    {
        private static const ONE_RECORD:String = "one";

        private static const COMPLEX_RECORD:String = "complex";

        private static const MISSING_RECORDS:String = "missing";

        private static var _externalFilesLoader:ExternalFilesLoader;

        [BeforeClass(async)]
        public static function setUpBeforeClass():void
        {
            _externalFilesLoader = new ExternalFilesLoader();
            _externalFilesLoader.addFileToLoad(ONE_RECORD, "data/OneRecord.csv");
            _externalFilesLoader.addFileToLoad(COMPLEX_RECORD, "data/ComplexRecord.csv");
            _externalFilesLoader.addFileToLoad(MISSING_RECORDS, "data/MissingRecords.csv");
            Async.proceedOnEvent(ZeoCSVParserTest, _externalFilesLoader, Event.COMPLETE);
        }

        [AfterClass]
        public static function tearDownAfterClass():void
        {
            _externalFilesLoader = null;
        }

        private var _zeoCSVParser:ZeoCSVParser;

        private var _progressEvents:Vector.<ProgressEvent>;

        private var _errorEvent:ErrorEvent;

        [Before]
        public function setUp():void
        {
            _zeoCSVParser = new ZeoCSVParser();
            _progressEvents = new Vector.<ProgressEvent>();
        }

        public function parseFile_OneRecordSync_ParsesFine(externalData:Object):void
        {
            assertNull(_zeoCSVParser.result);
            _zeoCSVParser.addEventListener(ErrorEvent.ERROR, captureErrorEvent);
            _zeoCSVParser.parse(createCSVParser(_externalFilesLoader.getFile(ONE_RECORD) as String), -1);
            failIfError();
            assertNotNull(_zeoCSVParser.result);
            assertEquals(1, _zeoCSVParser.result.length);
            assertOneRecord(_zeoCSVParser.result[0]);
        }

        [Test]
        public function parseFile_MissingRecordsSync_ParsesFine():void
        {
            assertNull(_zeoCSVParser.result);
            _zeoCSVParser.addEventListener(ErrorEvent.ERROR, captureErrorEvent);
            _zeoCSVParser.parse(createCSVParser(_externalFilesLoader.getFile(MISSING_RECORDS) as String), -1);
            failIfError();
            assertNotNull(_zeoCSVParser.result);
            assertEquals(35, _zeoCSVParser.result.length);
        }
        
        [Test]
        public function parseFile_ComplexRecordSync_ParsesFine():void
        {
            assertNull(_zeoCSVParser.result);
            _zeoCSVParser.addEventListener(ErrorEvent.ERROR, captureErrorEvent);
            _zeoCSVParser.parse(createCSVParser(_externalFilesLoader.getFile(COMPLEX_RECORD) as String), -1);
            failIfError();
            assertNotNull(_zeoCSVParser.result);
            assertEquals(1, _zeoCSVParser.result.length);

            var zeoData:ZeoDataEntry = _zeoCSVParser.result[0];
            assertEquals("This is,a, Complex Record\"Test", zeoData.notes);
        }

        [Test(async)]
        public function parseFile_OneRecordASync_ParsesFine():void
        {
            var asyncHandler:Function = Async.asyncHandler(this, verifyParseFile_OneRecordASync_ParsesFine, 500);
            _zeoCSVParser.addEventListener(Event.COMPLETE, asyncHandler);
            _zeoCSVParser.addEventListener(ProgressEvent.PROGRESS, captureProgressEvent);
            Async.failOnEvent(this, _zeoCSVParser, ErrorEvent.ERROR);
            assertNull(_zeoCSVParser.result);
            _zeoCSVParser.parse(createCSVParser(_externalFilesLoader.getFile(ONE_RECORD) as String), 1);
            assertNull(_zeoCSVParser.result);
        }

        private function verifyParseFile_OneRecordASync_ParsesFine(event:Event, passThroughData:Object):void
        {
            assertNotNull(_zeoCSVParser.result);
            assertEquals(1, _zeoCSVParser.result.length);
            assertOneRecord(_zeoCSVParser.result[0]);

            assertEquals(3, _progressEvents.length);
            var progressEvent:ProgressEvent = _progressEvents[0];
            assertEquals(883, progressEvent.bytesLoaded);
            assertEquals(3616, progressEvent.bytesTotal);
            progressEvent = _progressEvents[1];
            assertEquals(3616, progressEvent.bytesLoaded);
            assertEquals(3616, progressEvent.bytesTotal);
            progressEvent = _progressEvents[2];
            assertEquals(3616, progressEvent.bytesLoaded);
            assertEquals(3616, progressEvent.bytesTotal);
        }

        private function captureProgressEvent(progressEvent:ProgressEvent):void
        {
            _progressEvents.push(progressEvent);
        }

        private function assertOneRecord(zeoData:ZeoDataEntry):void
        {
            assertTrue(ZeoDateMother.createZeoDate(2009, 6, 30).equals(zeoData.sleepDate));

            assertEquals(73, zeoData.zq);

            assertEquals(392, zeoData.totalZ);

            assertEquals(3, zeoData.timeToZ);

            assertEquals(0, zeoData.timeInWake);

            assertEquals(96, zeoData.timeInREM);

            assertEquals(246, zeoData.timeInLight);

            assertEquals(51, zeoData.timeInDeep);

            assertEquals(0, zeoData.awakenings);

            assertTrue(ZeoDateTimeMother.createZeoDateTime(2009, 6, 30, 23, 20).equals(zeoData.startOfNight));

            assertTrue(ZeoDateTimeMother.createZeoDateTime(2009, 6, 31, 5, 58).equals(zeoData.endOfNight));

            assertTrue(ZeoDateTimeMother.createZeoDateTime(2009, 6, 31, 6, 00).equals(zeoData.riseTime));

            assertEquals(AlarmReason.NO_ALARM, zeoData.alarmReason);

            assertEquals(9, zeoData.snoozeTime);

            assertEquals(WakeTone.SUNRISE, zeoData.wakeTone);

            assertEquals(30, zeoData.wakeWindow);

            assertEquals(AlarmType.SMART_WAKE, zeoData.alarmType);

            assertNull(zeoData.firstAlarmRing);

            assertNull(zeoData.lastAlarmRing);

            assertNull(zeoData.firstSnoozeTime);

            assertNull(zeoData.lastSnoozeTime);

            assertTrue(ZeoDateTimeMother.createZeoDateTime(2009, 6, 31, 7, 00).equals(zeoData.setAlarmTime));

            assertEquals(MorningFeel.OKAY, zeoData.morningFeel);

            assertEquals(3, zeoData.dayFeel1);

            assertEquals(3, zeoData.dayFeel2);

            assertEquals(3, zeoData.dayFeel3);

            assertNull(zeoData.notes);

            assertEquals(0, zeoData.sleepStealers.fallAsleep);

            assertNull(zeoData.sleepStealers.anticipation);

            assertNull(zeoData.sleepStealers.tension);

            assertNull(zeoData.sleepStealers.comfort);

            assertNull(zeoData.sleepStealers.noise);

            assertNull(zeoData.sleepStealers.light);

            assertNull(zeoData.sleepStealers.temperature);

            assertNull(zeoData.sleepStealers.familiar);

            assertEquals(1, zeoData.sleepStealers.bedroom);

            assertEquals(0, zeoData.sleepStealers.disruption);

            assertNull(zeoData.sleepStealers.hotFlashes);

            assertNull(zeoData.sleepStealers.dreams);

            assertNull(zeoData.sleepStealers.fullness);

            assertNull(zeoData.sleepStealers.hunger);

            assertNull(zeoData.sleepStealers.heartburn);

            assertEquals(0, zeoData.sleepStealers.caffeine);

            assertEquals(0, zeoData.sleepStealers.alcohol);

            assertNull(zeoData.sleepStealers.thirst);

            assertNull(zeoData.sleepStealers.restroom);

            assertNull(zeoData.sleepStealers.windDown);

            assertEquals(1, zeoData.sleepStealers.sleepiness);

            assertNull(zeoData.sleepStealers.exercise);

            assertNull(zeoData.sleepStealers.timeBeforeBed);

            assertNull(zeoData.sleepStealers.conversations);

            assertEquals(1, zeoData.sleepStealers.activityLevel);

            assertNull(zeoData.sleepStealers.lateWork);

            assertNull(zeoData.sleepStealers.customField1);

            assertNull(zeoData.sleepStealers.customField2);

            assertNull(zeoData.sleepStealers.customField3);

            assertNull(zeoData.sleepStealers.customField4);

            assertNull(zeoData.sleepStealers.customField5);

            assertNull(zeoData.sleepStealers.customField6);

            assertNull(zeoData.sleepStealers.customField7);

            assertNull(zeoData.sleepStealers.customField8);

            assertNull(zeoData.sleepStealers.customField9);

            assertNull(zeoData.sleepStealers.customField10);

            assertNull(zeoData.sleepStealers.customField11);

            assertNull(zeoData.sleepStealers.customField12);

            assertNull(zeoData.sleepStealers.customField13);

            assertNull(zeoData.sleepStealers.customField14);

            assertNull(zeoData.sleepStealers.customField15);

            assertNull(zeoData.sleepStealers.customField16);

            assertNull(zeoData.sleepStealers.customField17);

            assertNull(zeoData.sleepStealers.customField18);

            assertNull(zeoData.sleepStealers.customField19);

            assertNull(zeoData.sleepStealers.customField20);

            assertNull(zeoData.sleepStealers.customField21);

            assertEquals(115, zeoData.sleepGraph.length);
            assertEquals(SleepStage.UNDEFINED, zeoData.sleepGraph[0]);
            assertEquals(SleepStage.REM, zeoData.sleepGraph[1]);
            assertEquals(SleepStage.REM, zeoData.sleepGraph[2]);
            assertEquals(SleepStage.LIGHT, zeoData.sleepGraph[4]);
            assertEquals(SleepStage.DEEP, zeoData.sleepGraph[8]);
            assertEquals(SleepStage.REM, zeoData.sleepGraph[16]);
            assertEquals(SleepStage.LIGHT, zeoData.sleepGraph[32]);
            assertEquals(SleepStage.REM, zeoData.sleepGraph[64]);
            assertEquals(SleepStage.UNDEFINED, zeoData.sleepGraph[114]);

            assertEquals(1154, zeoData.detailedSleepGraph.length);
            assertEquals(SleepStage.UNDEFINED, zeoData.detailedSleepGraph[0]);
            assertEquals(SleepStage.UNDEFINED, zeoData.detailedSleepGraph[1]);
            assertEquals(SleepStage.UNDEFINED, zeoData.detailedSleepGraph[2]);
            assertEquals(SleepStage.UNDEFINED, zeoData.detailedSleepGraph[4]);
            assertEquals(SleepStage.UNDEFINED, zeoData.detailedSleepGraph[8]);
            assertEquals(SleepStage.REM, zeoData.detailedSleepGraph[16]);
            assertEquals(SleepStage.LIGHT, zeoData.detailedSleepGraph[32]);
            assertEquals(SleepStage.LIGHT, zeoData.detailedSleepGraph[64]);
            assertEquals(SleepStage.LIGHT, zeoData.detailedSleepGraph[128]);
            assertEquals(SleepStage.DEEP, zeoData.detailedSleepGraph[256]);
            assertEquals(SleepStage.LIGHT, zeoData.detailedSleepGraph[512]);
            assertEquals(SleepStage.UNDEFINED, zeoData.detailedSleepGraph[1024]);
            assertEquals(SleepStage.UNDEFINED, zeoData.detailedSleepGraph[1153]);
        }

        private function captureErrorEvent(errorEvent:ErrorEvent):void
        {
            _errorEvent = errorEvent;
        }

        private function failIfError():void
        {
            if (_errorEvent != null)
            {
                fail(_errorEvent.text);
            }
        }
        
        private function createCSVParser(data:String):CSVParser
        {
            var csvParser:CSVParser = new CSVParser(data);
            csvParser.eol = Vector.<Number>([CSVParser.LF]);
            return csvParser;
        }
    }
}