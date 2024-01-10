import React, {FC, useState, useRef, useCallback} from "react";
import {PanResponder, Dimensions} from "react-native";
import Svg, {Path, Circle, G, Text, Polygon, Line} from "react-native-svg";

interface Props {
    handleSize?: number;
    handleColor?: string;
    dialRadius?: number;
    arcWidth?: number;
    arcColor?: string;
    meterTextColor?: string;
    fillColor?: string;
    strokeColor?: string;
    strokeWidth?: number;
    meterTextSize?: number;
    value?: number;
    minAngle?: number;
    maxAngle?: number;
    minValue?: number;
    maxValue?: number;
    xCenter?: number;
    yCenter?: number;
    onChange?: (x: number) => number;
    coerceToInt?: boolean;
    meterText?: string | number;
    capMode?: 'circle' | 'triangle'
}

const CircularSliderNativeLegacy: FC<Props> = ({
                                             handleSize = 15,
                                             handleColor = "#0cd",
                                             dialRadius = 130,
                                             arcWidth = 5,
                                             arcColor = "#0cd",
                                             meterTextColor = "#fff",
                                             fillColor = "none",
                                             strokeColor = "#fff",
                                             strokeWidth = 0.5,
                                             meterTextSize = 10,
                                             value = 0,
                                             minAngle = 0,
                                             maxAngle = 360,
                                             minValue = 0,
                                             maxValue = 360,
                                             xCenter = Dimensions.get("window").width / 2,
                                             yCenter = Dimensions.get("window").height / 2,
                                             onChange = (x) => x,
                                             coerceToInt = false,
                                             meterText = "None",
                                             capMode = 'triangle'
                                         }) => {
    const step = (maxAngle - minAngle) / (maxValue - minValue)

    const [angle, setAngle] = useState(value * step);

    // const onValueChange = (value: number) => {
    //     value = value / step
    //     onChange(value)
    // }

    const panResponder = useRef(
        PanResponder.create({
            onStartShouldSetPanResponder: (e, gs) => true,
            onStartShouldSetPanResponderCapture: (e, gs) => true,
            onMoveShouldSetPanResponder: (e, gs) => true,
            onMoveShouldSetPanResponderCapture: (e, gs) => true,
            onPanResponderMove: (e, gs) => {
                let xOrigin = xCenter - (dialRadius + handleSize);
                let yOrigin = yCenter - (dialRadius + handleSize);
                let a = cartesianToPolar(gs.moveX - xOrigin, gs.moveY - yOrigin);

                if (a <= minAngle) {
                    setAngle(minAngle);
                } else if (a >= maxAngle) {
                    setAngle(maxAngle);
                } else {

                    if (coerceToInt) {
                        a = Math.round(a / step) * step
                    }
                    setAngle(a);
                }
                onChange(Math.round(a) / step)
            },
        })
    ).current;

    const polarToCartesian = useCallback(
        (angle) => {
            let r = dialRadius;
            let hC = dialRadius + handleSize;
            let a = ((angle - 90) * Math.PI) / 180.0;

            let x = hC + r * Math.cos(a);
            let y = hC + r * Math.sin(a);
            return {x, y};
        },
        [dialRadius, handleSize]
    );

    const cartesianToPolar = useCallback(
        (x: number, y: number): number => {
            let hC = dialRadius + handleSize;

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
        [dialRadius, handleSize]
    );

    const width = (dialRadius + handleSize) * 2;
    const bR = handleSize;
    const dR = dialRadius;
    const startCoord = polarToCartesian(0);
    let endCoord = polarToCartesian(angle);

    // draws numeric ruler
    const stepRad = ((step <= 36 ? step : step / 10) * Math.PI) / 180

    const numbers = []
    for (let i = maxAngle; i > minAngle; i -= step) {
        numbers.push(Math.round(i / step))
    }

    const numX = width / 2
    const numY = numX + strokeWidth / 4
    // const numR = numX - bR*3
    const numR = numX - strokeWidth * 5 / 3

    return (
        <Svg width={width + strokeWidth} height={width}>
            <Circle
                r={dR}
                cx={width / 2}
                cy={width / 2}
                stroke={strokeColor}
                strokeWidth={strokeWidth}
                fill={fillColor}
            />

            <Path
                stroke={arcColor}
                strokeWidth={arcWidth}
                fill="none"
                d={`M${startCoord.x} ${startCoord.y} A ${dR} ${dR} 0 ${
                    angle > 180 ? 1 : 0
                } 1 ${endCoord.x} ${endCoord.y}`}
            />

            {numbers.map(value => {
                return (
                    <Text key={value}
                          x={numX + numR * Math.sin(value * stepRad)}
                          y={numY - numR * Math.cos(value * stepRad)}
                          fontSize={12} fill={meterTextColor} textAnchor="middle">
                        {value}
                    </Text>
                )
            })}

            {numbers.map(value => {
                return (
                    <Line key={`ticks${value}`}
                          x1={numX + (numX - strokeWidth / 3) * Math.sin(value * stepRad)}
                          y1={numX - (numX - strokeWidth / 3) * Math.cos(value * stepRad)}
                          x2={numX + (numX) * Math.sin(value * stepRad)}
                          y2={numX - (numX) * Math.cos(value * stepRad)}
                          stroke={handleColor}>
                    </Line>
                )
            })}

            <Text
                x={numX}
                y={numY + meterTextSize / 2}
                fontSize={meterTextSize}
                fill={meterTextColor}
                textAnchor="middle"
            >
                {meterText}
            </Text>

            <G x={endCoord.x - bR} y={endCoord.y - bR}>
                {capMode === "triangle"
                    ? <Polygon
                        points={`${bR},${bR + handleSize}
                                    ${bR + handleSize},${bR - handleSize} 
                                    ${bR - handleSize},${bR - handleSize}`}
                        fill={handleColor}
                        transform={`rotate(${angle} ${bR} ${bR})`}
                        {...panResponder.panHandlers}
                    />
                    : <Circle
                        r={bR}
                        cx={bR}
                        cy={bR}
                        fill={handleColor}
                        {...panResponder.panHandlers}
                    />}
            </G>

            <Circle  // panResponder place
                r={dR + arcWidth}
                cx={numX}
                cy={numX}
                fill={"transparent"}
                {...panResponder.panHandlers}
            />

        </Svg>
    );
};

export default React.memo(CircularSliderNativeLegacy);