import * as React from "react";
import {AngleDescription, angleToPosition, angleToValue, positionToAngle, valueToAngle} from "./circularGeometry";
import {arcPathWithRoundedEnds} from "./svgPaths";
import Svg, {Circle, Line, Path, Polygon, Text} from "react-native-svg";
import {Platform} from "react-native";


type HandleProps = {
    value: number;
    onChange: (value: number) => void;
    handleSize?: number;
    handleMode?: "circle" | "triangle"
}


type CircularSliderProps = {
    dialDiameter?: number;
    strokeWidth?: number;
    minValue?: number;
    maxValue?: number;
    startAngle?: number; // 0 - 360 degrees
    endAngle?: number; // 0 - 360 degrees
    angleType: AngleDescription;
    handleSize?: number;
    value: number;
    onChange: (value: number) => void;
    handle2?: HandleProps;
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
    handleMode?: "circle" | "triangle"
};


export default function CircularSliderNative({...props}: CircularSliderProps) {

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
        handleMode = 'triangle',
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

        let x: number, y: number;

        if (Platform.OS === "web") {
            // @ts-ignore  NOTE: this reference aren't in the react-native-svg docs
            const rect = ev.currentTarget.getBoundingClientRect();
            const touch = event.changedTouches[0];
            x = touch.clientX - rect.left;
            y = touch.clientY - rect.top;

        } else {
            // @ts-ignore  NOTE: this reference aren't in the react-native-svg docs
            x = event.locationX;
            // @ts-ignore  NOTE: this reference aren't in the react-native-svg docs
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

    const createHandle = (handlePosition) => {
        const triangleRotation = value * step + 180

        if (handleMode === "triangle") {
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

    const pathProps: any = {
        svgSize: dialDiameter,
        direction: angleType.direction,
        angleType: angleType,
    }

    const arcBackgroundProps: any = {
        innerRadius: trackInnerRadius,
        thickness: strokeWidth,
        ...pathProps
    }

    const arcProps: any = {
        innerRadius: (trackInnerRadius + strokeWidth / 2 - arcWidth / 2),
        thickness: arcWidth,
        ...pathProps
    }

    const numbersProps = (value: number): any => {
        const sin = Math.sin(value * stepRad)
        const cos = Math.cos(value * stepRad)
        return ({
            key: value,
            x: numX + (trackInnerRadius - strokeWidth / 2) * sin,
            y: numY - (trackInnerRadius - strokeWidth / 2) * cos,
            fontSize: 12,
            fill: handleColor,
            textAnchor: "middle"
        })
    }

    const ticksProps = (value: number): any => {
        const sin = Math.sin(value * stepRad)
        const cos = Math.cos(value * stepRad)
        return ({
            key: `ticks${value}`,
            x1: numX + (trackInnerRadius + 2 / 3 * strokeWidth) * sin,
            y1: numX - (trackInnerRadius + 2 / 3 * strokeWidth) * cos,
            x2: numX + (trackInnerRadius + strokeWidth) * sin,
            y2: numX - (trackInnerRadius + strokeWidth) * cos,
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
                            ...arcBackgroundProps
                        })}
                        fill={strokeColor}
                    />
                    {/* Arc (render after background so it overlays it) */}
                    <Path
                        d={arcPathWithRoundedEnds({
                            startAngle,
                            endAngle: handleAngle,
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
                            ...arcBackgroundProps
                        })}
                        fill={strokeColor}
                    />
                    {/* Arc Background Part 2  */}
                    <Path
                        d={arcPathWithRoundedEnds({
                            startAngle: handle2Angle,
                            endAngle,
                            ...arcBackgroundProps
                        })}
                        fill={strokeColor}
                    />
                    {/* Arc (render after background so it overlays it) */}
                    <Path
                        d={arcPathWithRoundedEnds({
                            startAngle: handleAngle,
                            endAngle: handle2Angle,
                            ...arcProps
                        })}
                        fill={arcColor}
                    />
                </React.Fragment>
            )}

            <Text {...meterTextProps}>{meterText}</Text>
            {numbers.map(value => <Line {...ticksProps(value)} />)}
            {numbers.map(value => <Text {...numbersProps(value)}>{value}</Text>)}
            {controllable && <React.Fragment>{createHandle(handlePosition)}</React.Fragment>}
            {handle2Position && <React.Fragment>{createHandle(handle2Position)}</React.Fragment>}
        </Svg>
    )
}