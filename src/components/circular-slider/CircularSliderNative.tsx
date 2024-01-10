import {useRef, useState} from "react";
import * as React from "react";
import {AngleDescription, angleToPosition, angleToValue, positionToAngle, valueToAngle} from "./circularGeometry";
import {arcPathWithRoundedEnds} from "./svgPaths";
import Svg, {Circle, Line, Path, Polygon, Text} from "react-native-svg";
import {Platform, TouchableOpacity, View} from "react-native";


type Props = {
    dialDiameter?: number;
    strokeWidth?: number;
    minValue?: number;
    maxValue?: number;
    startAngle?: number; // 0 - 360 degrees
    endAngle?: number; // 0 - 360 degrees
    angleType: AngleDescription;
    handleSize?: number;
    value: number,
    onChange: (value: number) => void,
    handle2?: {
        value: number;
        onChange: (value: number) => void;
    };
    onControlFinished?: () => void;
    disabled?: boolean;
    arcColor?: string;
    arcWidth?: number,
    strokeColor?: string;
    coerceToInt?: boolean;
    btnRadius?: number;
    handleColor?: string;
    meterText?: string;
    meterTextColor?: string;
    meterTextSize?: number;
    capMode?: "circle" | "triangle"
};


export default function CircularSliderNative({...props}: Props) {

    const {
        dialDiameter = 200,
        strokeWidth = 4,
        value,
        onChange,
        handle2,
        handleSize = 8,
        maxValue = 0,
        minValue = 360,
        startAngle = 0,
        endAngle = 360,
        angleType = {
            direction: "cw",
            axis: "-y",
        },
        disabled,
        arcColor = "#0cd",
        strokeColor = "#aaa",
        capMode = 'triangle',
        handleColor = "#0cd",
        arcWidth = 10,
        meterText = "None",
        meterTextColor = "#0cd",
        meterTextSize = 10,
        coerceToInt = false,
        onControlFinished
    } = props;

    // const svgRef = useRef<SVGSVGElement | null>(null)
    // const viewRef = useRef<View | null>(null)

    const onTouch = (ev: React.TouchEvent<Svg>) => {
        /* This is a very simplistic touch handler. Some optimzations might be:
            - Right now, the bounding box for a touch is the entire element. Having the bounding box
              for touched be circular at a fixed distance around the slider would be more intuitive.
            - Similarly, don't set `touchAction: 'none'` in CSS. Instead, call `ev.preventDefault()`
              only when the touch is within X distance from the slider
        */

        // This simple touch handler can't handle multiple touches. Therefore, bail if there are either:
        // - more than 1 touches currently active
        // - a touchEnd event, but there is still another touch active
        if (!onChange) {
            // Read-only, don't bother doing calculations
            return;
        }

        const event = ev.nativeEvent

        if (
            event.touches.length > 1 ||
            (event.type === "touchend" && event.touches.length > 0)
        ) {
            return;
        }

        // Process the new position

        let x, y: number

        if (Platform.OS === "web") {
            const rect = ev.currentTarget.getBoundingClientRect();
            const touch = event.changedTouches[0];
            x = touch.clientX - rect.left;
            y = touch.clientY - rect.top;

        } else {
            // @ts-ignore  NOTE: doesn't in the rn svg docs
            x = event.locationX;
            // @ts-ignore  NOTE: doesn't in the rn svg docs
            y = event.locationY;
        }

        processSelection(x, y)

        // If the touch is ending, fire onControlFinished
        if (event.type === "touchend" || event.type === "touchcancel") {
            if (onControlFinished) {
                onControlFinished();
            }
        }
    };

    const processSelection = (x: number, y: number) => {

        const coordsInSvg = {x: x, y: y}
        const angle = positionToAngle(coordsInSvg, dialDiameter, angleType);

        let _value = angleToValue({
            angle,
            minValue,
            maxValue,
            startAngle,
            endAngle,
        });
        if (coerceToInt) {
            _value = Math.round(_value);
        }

        if (!disabled) {
            if (
                handle2 &&
                handle2.onChange &&
                // make sure we're closer to handle 2 -- i.e. controlling handle2
                Math.abs(_value - handle2.value) < Math.abs(_value - value)
            ) {
                handle2.onChange(_value);
            } else {
                onChange(_value);
            }
        }
    }

    const trackInnerRadius = dialDiameter / 2 - strokeWidth;
    const handleAngle = valueToAngle({
        value: value,
        minValue,
        maxValue,
        startAngle,
        endAngle,
    });

    const handle2Angle =
        handle2 &&
        valueToAngle({
            value: handle2.value,
            minValue,
            maxValue,
            startAngle,
            endAngle,
        });

    const handlePosition = angleToPosition(
        {degree: handleAngle, ...angleType},
        trackInnerRadius + strokeWidth / 2,
        dialDiameter
    );

    const handle2Position =
        handle2Angle &&
        angleToPosition(
            {degree: handle2Angle, ...angleType},
            trackInnerRadius + strokeWidth / 2,
            dialDiameter
        );

    const controllable = !disabled && Boolean(onChange);

    const createCap = () => {
        const triangleRotation = value * step + 180

        if (capMode === "triangle") {
            return (
                <Polygon
                    points={`${handlePosition.x},${handlePosition.y - handleSize} 
             ${handlePosition.x - handleSize},${handlePosition.y + handleSize} 
             ${handlePosition.x + handleSize},${handlePosition.y + handleSize}`}
                    fill={handleColor}
                    transform={`rotate(${triangleRotation} ${handlePosition.x} ${handlePosition.y})`}
                />
            )
        } else {
            return (
                <Circle
                    r={handleSize}
                    cx={handlePosition.x}
                    cy={handlePosition.y}
                    fill={handleColor}
                />
            )
        }
    }

    const step = (endAngle - startAngle) / (maxValue - minValue)
    const stepRad = ((step <= 36 ? step : step / 10) * Math.PI) / 180
    const numX = dialDiameter / 2
    const numY = numX + strokeWidth / 4
    // const numR = numX - strokeWidth * 5/2
    const numbers = []
    for (let i = endAngle; i > startAngle; i -= step) {
        numbers.push(Math.round(i / step))
    }

    const svgRootProps: any = {
        width: dialDiameter,
        height: dialDiameter,
        onClick: (ev) => controllable && ev.stopPropagation(),

        onTouchStart: onTouch,
        onTouchEnd: onTouch,
        onTouchMove: onTouch,
        onTouchCancel: onTouch,

        style: {touchAction: "none"}
    }

    const meterTextProps: any = {
        x: dialDiameter / 2,
        y: dialDiameter / 2 + 10,
        fontSize: meterTextSize,
        fill: meterTextColor,
        textAnchor: "middle"
    }

    const arcBackgroundProps: any = {
        thickness: strokeWidth,
        svgSize: dialDiameter,
        direction: angleType.direction,
    }

    const arcProps: any = {
        thickness: arcWidth,
        svgSize: dialDiameter,
        direction: angleType.direction,
    }

    const numbersProps = (value: number): any => {
        return ({
            key: value,
            x: numX + (trackInnerRadius - strokeWidth / 2) * Math.sin(value * stepRad),
            y: numY - (trackInnerRadius - strokeWidth / 2) * Math.cos(value * stepRad),
            fontSize: 12,
            fill: handleColor,
            textAnchor: "middle"
        })
    }

    const ticksProps = (value: number): any => {
        return ({
            key: `ticks${value}`,
            x1: numX + (trackInnerRadius + 2 / 3 * strokeWidth) * Math.sin(value * stepRad),
            y1: numX - (trackInnerRadius + 2 / 3 * strokeWidth) * Math.cos(value * stepRad),
            x2: numX + (trackInnerRadius + strokeWidth) * Math.sin(value * stepRad),
            y2: numX - (trackInnerRadius + strokeWidth) * Math.cos(value * stepRad),
            stroke: handleColor,
        })
    }

    return (
        <Svg {...svgRootProps} >
            {handle2Angle === undefined ? (
                /* One-handle mode */
                <React.Fragment>
                    {/* Arc Background  */}
                    <Path
                        d={arcPathWithRoundedEnds({
                            startAngle: handleAngle,
                            endAngle,
                            angleType,
                            innerRadius: trackInnerRadius,
                            ...arcBackgroundProps
                        })}
                        fill={strokeColor}
                    />
                    {/* Arc (render after background so it overlays it) */}
                    <Path
                        d={arcPathWithRoundedEnds({
                            startAngle,
                            endAngle: handleAngle,
                            angleType,
                            innerRadius: (trackInnerRadius + strokeWidth / 2 - arcWidth / 2),
                            ...arcProps
                        })}
                        fill={arcColor}
                    />
                </React.Fragment>
            ) : (
                /* Two-handle mode */
                <React.Fragment>
                    {/* Arc Background Part 1  */}
                    <Path
                        d={arcPathWithRoundedEnds({
                            startAngle,
                            endAngle: handleAngle,
                            angleType,
                            innerRadius: trackInnerRadius,
                            ...arcBackgroundProps
                        })}
                        fill={strokeColor}
                    />
                    {/* Arc Background Part 2  */}
                    <Path
                        d={arcPathWithRoundedEnds({
                            startAngle: handle2Angle,
                            endAngle,
                            angleType,
                            innerRadius: trackInnerRadius,
                            ...arcBackgroundProps
                        })}
                        fill={strokeColor}
                    />
                    {/* Arc (render after background so it overlays it) */}
                    <Path
                        d={arcPathWithRoundedEnds({
                            startAngle: handleAngle,
                            endAngle: handle2Angle,
                            angleType,
                            innerRadius: trackInnerRadius,
                            ...arcProps

                        })}
                        fill={arcColor}
                    />
                </React.Fragment>
            )}

            {numbers.map(value => <Text {...numbersProps(value)}>{value}</Text>)}
            {numbers.map(value => <Line {...ticksProps(value)} />)}
            <Text {...meterTextProps}>{meterText}</Text>
            { /* Handle 1 */ controllable && <React.Fragment>{createCap()}</React.Fragment>}

            {
                /* Handle 2 */
                handle2Position && (
                    <React.Fragment>
                        <Circle
                            r={handleSize}
                            cx={handle2Position.x}
                            cy={handle2Position.y}
                            fill="#ffffff"
                        />
                    </React.Fragment>
                )
            }
        </Svg>
    )
}