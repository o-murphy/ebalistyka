import React, {FC, useState, useRef, useCallback} from "react";
import {PanResponder, Dimensions, type ColorValue} from "react-native";
import Svg, {Path, Circle, G, Text, Polygon} from "react-native-svg";

interface Props {
    btnRadius?: number;
    btnColor?: string;
    dialRadius?: number;
    dialWidth?: number;
    meterColor?: string;
    textColor?: string;
    fillColor?: string;
    strokeColor?: string;
    strokeWidth?: number;
    textSize?: number;
    value?: number;
    min?: number;
    max?: number;
    xCenter?: number;
    yCenter?: number;
    onValueChange?: (x: number) => number;
}

const CircleSlider: FC<Props> = ({
                                     btnRadius = 15,
                                     btnColor = "#0cd",
                                     dialRadius = 130,
                                     dialWidth = 5,
                                     meterColor = "#0cd",
                                     textColor = "#fff",
                                     fillColor = "none",
                                     strokeColor = "#fff",
                                     strokeWidth = 0.5,
                                     textSize = 10,
                                     value = 0,
                                     min = 0,
                                     max = 359,
                                     xCenter = Dimensions.get("window").width / 2,
                                     yCenter = Dimensions.get("window").height / 2,
                                     onValueChange = (x) => x,
                                 }) => {
    const [angle, setAngle] = useState(value);

    const onChange = (value) => {
        onValueChange(value)
        return value
    }

    const panResponder = useRef(
        PanResponder.create({
            onStartShouldSetPanResponder: (e, gs) => true,
            onStartShouldSetPanResponderCapture: (e, gs) => true,
            onMoveShouldSetPanResponder: (e, gs) => true,
            onMoveShouldSetPanResponderCapture: (e, gs) => true,
            onPanResponderMove: (e, gs) => {
                let xOrigin = xCenter - (dialRadius + btnRadius);
                let yOrigin = yCenter - (dialRadius + btnRadius);
                let a = cartesianToPolar(gs.moveX - xOrigin, gs.moveY - yOrigin);

                if (a <= min) {
                    setAngle(min);
                } else if (a >= max) {
                    setAngle(max);
                } else {
                    setAngle(a);
                }
            },
        })
    ).current;

    const polarToCartesian = useCallback(
        (angle) => {
            let r = dialRadius;
            let hC = dialRadius + btnRadius;
            let a = ((angle - 90) * Math.PI) / 180.0;

            let x = hC + r * Math.cos(a);
            let y = hC + r * Math.sin(a);
            return {x, y};
        },
        [dialRadius, btnRadius]
    );

    const cartesianToPolar = useCallback(
        (x, y) => {
            let hC = dialRadius + btnRadius;

            if (x === 0) {
                return y > hC ? 0 : 180;
            } else if (y === 0) {
                return x > hC ? 90 : 270;
            } else {
                return (
                    Math.round((Math.atan((y - hC) / (x - hC)) * 180) / Math.PI) +
                    (x > hC ? 90 : 270)
                );
            }
        },
        [dialRadius, btnRadius]
    );

    const width = (dialRadius + btnRadius) * 2;
    const bR = btnRadius;
    const dR = dialRadius;
    const startCoord = polarToCartesian(0);
    let endCoord = polarToCartesian(angle);

    return (
        <Svg width={width} height={width}>
            <Circle
                r={dR}
                cx={width / 2}
                cy={width / 2}
                stroke={strokeColor}
                strokeWidth={strokeWidth}
                fill={fillColor}
            />

            <Path
                stroke={meterColor}
                strokeWidth={dialWidth}
                fill="none"
                d={`M${startCoord.x} ${startCoord.y} A ${dR} ${dR} 0 ${
                    angle > 180 ? 1 : 0
                } 1 ${endCoord.x} ${endCoord.y}`}
            />

            <G x={endCoord.x - bR} y={endCoord.y - bR}>
                {/*<Circle*/}
                {/*    r={bR}*/}
                {/*    cx={bR}*/}
                {/*    cy={bR}*/}
                {/*    fill={btnColor}*/}
                {/*    {...panResponder.panHandlers}*/}
                {/*/>*/}

                <Polygon
                    points={`
                     ${bR},${bR + width / 4}
                     ${bR + 1.5 * btnRadius},${bR} 
                     ${bR - 1.5 * btnRadius},${bR} 
                    `}
                    fill={btnColor}
                    transform={`rotate(${angle} ${bR} ${bR})`}
                    {...panResponder.panHandlers}
                >
                    {onChange(angle) + ""}
                </Polygon>

                {/*<Polygon*/}
                {/*    points={`*/}
                {/*     ${bR - btnRadius},${bR+width/2 - 5*btnRadius} */}
                {/*     ${bR},${bR+width/2 - btnRadius}*/}
                {/*     ${bR + btnRadius},${bR+width/2 - 5*btnRadius} */}
                {/*     ${bR + btnRadius},${bR} */}
                {/*     ${bR - btnRadius},${bR} */}
                {/*    `}*/}
                {/*    fill={btnColor}*/}
                {/*    transform={`rotate(${angle} ${bR} ${bR})`}*/}
                {/*    {...panResponder.panHandlers}*/}
                {/*>*/}
                {/*    {onChange(angle) + ""}*/}
                {/*</Polygon>*/}

                {/*<Polygon*/}
                {/*    points={`${bR},${bR+btnRadius} */}
                {/*     ${bR + btnRadius},${bR - btnRadius} */}
                {/*     ${bR - btnRadius},${bR - btnRadius} `}*/}
                {/*    fill={btnColor}*/}
                {/*    transform={`rotate(${angle} ${bR} ${bR})`}*/}
                {/*    {...panResponder.panHandlers}*/}

                {/*>*/}
                {/*{onChange(angle) + ""}*/}
                {/*</Polygon>*/}


                {/*<Text*/}
                {/*    x={bR - btnRadius}*/}
                {/*    y={bR + textSize / 2 - btnRadius}*/}
                {/*    fontSize={textSize}*/}
                {/*    fill={textColor}*/}
                {/*    textAnchor="middle"*/}
                {/*>*/}
                {/*    {onChange(angle) + ""}*/}
                {/*</Text>*/}
            </G>
        </Svg>
    );
};

export default React.memo(CircleSlider);