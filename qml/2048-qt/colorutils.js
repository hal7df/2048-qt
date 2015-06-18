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
        return "#ff4444"
    else if (power == 1)  //2
        return "#2cb1e1";
    else if (power == 2)  //4
        return "#16a5d7";
    else if (power == 3)  //8
        return "#0099cc";
    else if (power == 4)  //16
        return "#c58be2";
    else if (power == 5)  //32
        return "#ac59d6";
    else if (power == 6)  //64
        return "#9933cc";
    else if (power == 7)  //128
        return "#92c500";
    else if (power == 8)  //256
        return "#7caf00";
    else if (power == 9)  //512
        return "#669900";
    else if (power == 10) //1024
        return "#ffc641";
    else if (power == 11) //2048
        return "#ffb61c";
    else if (power == 12) //4096
        return "#ffa713";
    else if (power == 13) //8192
        return "#ff9909";
    else if (power >= 14) //16384+
        return "#ff8a00";
}

function getContrasting (hex)
{
    var num = hex.toString();
    num = num.substring(1);

    var r = parseInt(num.substr(0,2),16);
    var g = parseInt(num.substr(2,2),16);
    var b = parseInt(num.substr(4,2),16);
    var yiq = ((r*299)+(g*587)+(b*114))/1000;
    return (yiq >= 128) ? "#000000" : "#ffffff";
}

