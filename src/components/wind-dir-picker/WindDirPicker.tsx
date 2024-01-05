import {Text, useTheme} from "react-native-paper";
import React from "react";
import {View} from "react-native";
import CircularSlider from "../circular-slider";


export default function WindDirection({curValue, onChange}) {
    const theme = useTheme()

    const styles = {
        container: {
            flex: 1,
            justifyContent: 'center',
            alignItems: 'center',
            paddingBottom: 40,
        },
        text: {
            marginTop: -110
        },
        slider: {
        },
    }

    return (

        <View style={styles.container}>
                <CircularSlider
                    // style={styles.slider}

                    size={200}
                    trackWidth={15}
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
                />

            <Text style={styles.text}>{`${curValue * 30}° (${curValue}h)`}</Text>

        </View>
    )
}