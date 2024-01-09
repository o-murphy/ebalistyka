import {Text, useTheme} from "react-native-paper";
import React from "react";
import {View} from "react-native";
import CircularSliderNative from "../circular-slider/CircularSliderNative";
import CircularSlider from "../circular-slider/web";

import {Platform} from "react-native";


export default function WindDirection({curValue, onChange}) {
    const theme = useTheme()

    const styles = {
        container: {
            // flex: 1,
            justifyContent: 'center',
            alignItems: 'center',
            paddingBottom: 40,
        },
        text: {
            marginTop: -110,
            fontWeight: "bold",
            fontSize: 16,
            textAlign: "center"
        },
        slider: {
            padding: 5
        },
    }

    return (

        <View style={styles.container}>

            {Platform.OS === "web"
                ?
                <CircularSlider
                    size={240}
                    trackWidth={20}
                    minValue={0}
                    maxValue={12}
                    startAngle={0}
                    endAngle={360}
                    angleType={{
                        direction: "cw",
                        axis: "+y"
                    }}
                    handle1={{
                        value: curValue,
                        onChange: onChange
                    }}
                    coerceToInt={true}
                    // arcColor={theme.colors.onSecondaryContainer}
                    arcColor={theme.colors.secondaryContainer}
                    arcBackgroundColor={theme.colors.secondaryContainer}
                    btnColor={theme.colors.outline}
                />
                :
                <CircularSliderNative
                    value={curValue}
                    dialRadius={80}
                    btnRadius={15}
                    btnColor={theme.colors.outline}
                    minAngle={0}
                    maxAngle={360}
                    minValue={0}
                    maxValue={12}
                    dialWidth={15}
                    meterColor={theme.colors.secondaryContainer}
                    textColor={theme.colors.onSecondaryContainer}
                    // fillColor={theme.colors.secondaryContainer}
                    strokeColor={theme.colors.secondaryContainer}
                    strokeWidth={20}
                    textSize={0}
                    onValueChange={onChange}
                    style={styles.slider}
                    coerceToInt={true}
                />
            }


            <Text style={styles.text}>{`${curValue * 30}°\n(${curValue}h)`}</Text>


        </View>
    )
}