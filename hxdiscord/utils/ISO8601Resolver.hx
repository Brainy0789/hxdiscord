package hxdiscord.utils;

using StringTools;

/**
    The ISO8601 class for Discord. This is used for Discord's date system
**/

class ISO8601Resolver {
    /**
        Returns an ISO8601 formatted string about the current date
    **/
    public static function getActualISODate():String {
        return DateTools.format(Date.now(), "%Y-%m-%dT%H:%M:%S." + Std.string(haxe.Timer.stamp() * 10000).split(".")[1] + "Z"); 
        // Note: Might need adjustment for JS targets.
    }

    /**
        Returns an ISO8601 formatted string about the calculated time you want
        @param time Enter the time you wanna calculate (i.e 10m)
        @param returnMilliseconds Whether to return milliseconds or not
    **/
    public static function getCalculatedISODate(time:String, ?returnMilliseconds:Bool):String {
        var dateToReturn:String = "";

        var validUnits = ['s', 'm', 'h', 'd', 'w', 'M', 'y']; // lowercase months changed to 'M' to avoid confusion
        var lastThing:String = time.charAt(time.length - 1);

        if (validUnits.indexOf(lastThing) == -1 && validUnits.indexOf(lastThing.toUpperCase()) == -1) {
            throw "Either you specified an invalid parameter or you didn't specify it";
        }

        var theOtherParameter:Float = Std.parseFloat(time.substr(0, time.length - 1));
        var timeToAddInMS:Float = 0;

        var date:Date = new Date(
            Date.now().getUTCFullYear(),
            Date.now().getUTCMonth(),
            Date.now().getUTCDate(),
            Date.now().getUTCHours(),
            Date.now().getUTCMinutes(),
            Date.now().getUTCSeconds()
        );

        switch(lastThing.toLowerCase()) {
            case "s":
                timeToAddInMS = 1000;
            case "m": // minutes
                timeToAddInMS = 60000;
            case "h":
                timeToAddInMS = 3600000;
            case "d":
                timeToAddInMS = 86400000;
            case "w":
                timeToAddInMS = 7 * 86400000; // 7 days in ms
            case "M": // months (uppercase M) — handle separately
                timeToAddInMS = 2629800000;
            case "y":
                timeToAddInMS = 2629800000 * 12;
        }

        var deltaDate = DateTools.delta(date, timeToAddInMS * theOtherParameter);

        if (returnMilliseconds) {
            dateToReturn = DateTools.format(deltaDate, "%Y-%m-%dT%H:%M:%S." + Std.string(haxe.Timer.stamp() * 10000).split(".")[1] + "Z");
        } else {
            dateToReturn = DateTools.format(deltaDate, "%Y-%m-%dT%H:%M:%S.000Z");
        }

        return dateToReturn;
    }
}
