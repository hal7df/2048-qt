function getSource(iconName,height) {
    if (height <= 18)
        return "images/xxldpi/ic_"+iconName+".png"; //18px
    else if (height > 18 && height <= 24)
        return "images/xldpi/ic_"+iconName+".png"; //24px
    else if (height > 24 && height <= 36)
        return "images/ldpi/ic_"+iconName+".png"; //36px
    else if (height > 36 && height <= 48)
        return "images/mdpi/ic_"+iconName+".png"; //48px
    else if (height > 48 && height <= 72)
        return "images/hdpi/ic_"+iconName+".png"; //72px
    else if (height > 72)
        return "images/xhdpi/ic_"+iconName+".png"; //96px
    else
        return "";
}
