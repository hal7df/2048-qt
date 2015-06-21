function getTextColor (value) {
   if (value != 0)
       return getContrasting(getBackgroundColor(value))
   else
       return "#00000000";
}

function getBackgroundColor (value) {

    var power;
    power = (Math.log(value)/Math.log(2));

    if (value == 0)  //Empty tile
        return "#00000000";
    else if ((power % 1) != 0) //Invalid tile
        return "#f44336"
    else if (power == 1)  //2
        return "#81d4fa";
    else if (power == 2)  //4
        return "#03a9f4";
    else if (power == 3)  //8
        return "#0277bd";
    else if (power == 4)  //16
        return "#b39ddb";
    else if (power == 5)  //32
        return "#7e57c2";
    else if (power == 6)  //64
        return "#512da8";
    else if (power == 7)  //128
        return "#81c784";
    else if (power == 8)  //256
        return "#4caf50";
    else if (power == 9)  //512
        return "#388e3c";
    else if (power == 10) //1024
        return "#ffca28";
    else if (power == 11) //2048
        return "#ffb300";
    else if (power == 12) //4096
        return "#ff9800";
    else if (power == 13) //8192
        return "#f57c00";
    else if (power >= 14) //16384+
        return "#ff5722";
}

function getContrasting (hex)
{
    var num = hex.toString();
    num = num.substring(1);

    var r = parseInt(num.substr(0,2),16);
    var g = parseInt(num.substr(2,2),16);
    var b = parseInt(num.substr(4,2),16);
    var yiq = ((r*299)+(g*587)+(b*114))/1000;
    return (yiq >= 128) ? "black" : "white";
}

