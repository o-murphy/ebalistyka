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

    const sliderProps = {
        coerceToInt: true,

        handleSize: 10,
        arcWidth: 20,
        strokeWidth: 20,
        meterTextSize: 20,

        handleColor: theme.colors.outline,
        arcColor: theme.colors.secondaryContainer,
        strokeColor: theme.colors.secondaryContainer,
        meterTextColor: theme.colors.outline,
    }

    const sliderValues = {
        minValue: 0,
        maxValue: 12,
        meterText: `${curValue * 30}° (${curValue}h)`
    }

    const sliderValueHandler = {
        value: curValue,
        onChange: onChange
    }

    return (
        <View style={styles.container}>

            {Platform.OS === "web"
                ?
                <CircularSlider
                    dialDiameter={240}
                    handle1={sliderValueHandler}
                    {...sliderProps}
                    {...sliderValues}
                    angleType={{
                        direction: "cw",
                        axis: "+y"
                    }}
                    style={styles.slider}
                />
                :
                <CircularSliderNative
                    dialRadius={80}
                    {...sliderValueHandler}
                    {...sliderProps}
                    {...sliderValues}
                    style={styles.slider}
                />}
        </View>
    )
}