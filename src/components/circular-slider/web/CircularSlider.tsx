import * as React from "react";
import {
    angleToPosition,
    positionToAngle,
    AngleDescription,
    valueToAngle,
    angleToValue,
} from "./circularGeometry";
import { arcPathWithRoundedEnds } from "./svgPaths";
import {Line, Text} from "react-native-svg";

type Props = {
    dialDiameter: number;
    strokeWidth: number;
    minValue: number;
    maxValue: number;
    startAngle: number; // 0 - 360 degrees
    endAngle: number; // 0 - 360 degrees
    angleType: AngleDescription;
    handleSize: number;
    handle1: {
        value: number;
        onChange?: (value: number) => void;
    };
    handle2?: {
        value: number;
        onChange: (value: number) => void;
    };
    onControlFinished?: () => void;
    disabled?: boolean;
    arcColor: string;
    arcWidth: number,
    strokeColor: string;
    coerceToInt?: boolean;
    capMode?: "circle" | "triangle"
    btnRadius?: number;
    handleColor?: string;
    meterText?: string;
    meterTextColor?: string;
    meterTextSize?: number;
};

export class CircularSlider extends React.Component<
    React.PropsWithChildren<Props>
> {
    static defaultProps: Pick<
        Props,
        | "dialDiameter"
        | "strokeWidth"
        | "minValue"
        | "maxValue"
        | "startAngle"
        | "endAngle"
        | "angleType"
        | "strokeColor"
        | "handleSize"
        | "capMode"
        | "handleColor"
        | "meterText"
        | "meterTextColor"
        | "meterTextSize"
        | "arcWidth"
    > = {
        dialDiameter: 200,
        strokeWidth: 4,
        minValue: 0,
        maxValue: 100,
        startAngle: 0,
        endAngle: 360,
        angleType: {
            direction: "cw",
            axis: "-y",
        },
        handleSize: 8,
        strokeColor: "#aaa",
        capMode: "triangle",
        handleColor: "#0cd",
        meterText: "None",
        meterTextColor: "#0cd",
        meterTextSize: 10,
        arcWidth: 10
    };
    svgRef = React.createRef<SVGSVGElement>();

    render() {
        const {
            dialDiameter,
            strokeWidth,
            handle1,
            handle2,
            handleSize,
            maxValue,
            minValue,
            startAngle,
            endAngle,
            angleType,
            disabled,
            arcColor,
            strokeColor,
            capMode,
            handleColor,
            arcWidth,
            meterText,
            meterTextColor,
            meterTextSize
        } = this.props;

        // const svgRef = useRef<SVGSVGElement | null>(null);  # TODO


        const onMouseEnter = (ev: React.MouseEvent<SVGSVGElement>) => {
            if (ev.buttons === 1) {
                // The left mouse button is pressed, act as though user clicked us
                onMouseDown(ev);
            }
        };

        const onMouseDown = (ev: React.MouseEvent<SVGSVGElement>) => {
            const svgRef = this.svgRef.current;
            if (svgRef) {
                svgRef.addEventListener("mousemove", handleMousePosition);
                svgRef.addEventListener("mouseleave", removeMouseListeners);
                svgRef.addEventListener("mouseup", removeMouseListeners);
            }
            handleMousePosition(ev);
        };

        const removeMouseListeners = () => {
            const svgRef = this.svgRef.current;
            if (svgRef) {
                svgRef.removeEventListener("mousemove", handleMousePosition);
                svgRef.removeEventListener("mouseleave", removeMouseListeners);
                svgRef.removeEventListener("mouseup", removeMouseListeners);
            }
            if (this.props.onControlFinished) {
                this.props.onControlFinished();
            }
        };

        const handleMousePosition = (ev: React.MouseEvent<SVGSVGElement> | MouseEvent) => {
            const x = ev.clientX;
            const y = ev.clientY;
            processSelection(x, y);
        };

        const onTouch = (ev: React.TouchEvent<SVGSVGElement>) => {
            /* This is a very simplistic touch handler. Some optimzations might be:
                - Right now, the bounding box for a touch is the entire element. Having the bounding box
                  for touched be circular at a fixed distance around the slider would be more intuitive.
                - Similarly, don't set `touchAction: 'none'` in CSS. Instead, call `ev.preventDefault()`
                  only when the touch is within X distance from the slider
            */

            // This simple touch handler can't handle multiple touches. Therefore, bail if there are either:
            // - more than 1 touches currently active
            // - a touchEnd event, but there is still another touch active
            if (
                ev.touches.length > 1 ||
                (ev.type === "touchend" && ev.touches.length > 0)
            ) {
                return;
            }

            // Process the new position
            const touch = ev.changedTouches[0];
            const x = touch.clientX;
            const y = touch.clientY;
            processSelection(x, y);

            // If the touch is ending, fire onControlFinished
            if (ev.type === "touchend" || ev.type === "touchcancel") {
                if (this.props.onControlFinished) {
                    this.props.onControlFinished();
                }
            }
        };

        const processSelection = (x: number, y: number) => {
            const {
                dialDiameter,
                maxValue,
                minValue,
                angleType,
                startAngle,
                endAngle,
                handle1,
                disabled,
                handle2,
                coerceToInt,
            } = this.props;
            if (!handle1.onChange) {
                // Read-only, don't bother doing calculations
                return;
            }
            const svgRef = this.svgRef.current;
            if (!svgRef) {
                return;
            }
            // Find the coordinates with respect to the SVG
            const svgPoint = svgRef.createSVGPoint();
            svgPoint.x = x;
            svgPoint.y = y;
            const coordsInSvg = svgPoint.matrixTransform(
                svgRef.getScreenCTM()?.inverse()
            );

            const angle = positionToAngle(coordsInSvg, dialDiameter, angleType);
            let value = angleToValue({
                angle,
                minValue,
                maxValue,
                startAngle,
                endAngle,
            });
            if (coerceToInt) {
                value = Math.round(value);
            }

            if (!disabled) {
                if (
                    handle2 &&
                    handle2.onChange &&
                    // make sure we're closer to handle 2 -- i.e. controlling handle2
                    Math.abs(value - handle2.value) < Math.abs(value - handle1.value)
                ) {
                    handle2.onChange(value);
                } else {
                    handle1.onChange(value);
                }
            }
        };

        const shadowWidth = 20;
        const trackInnerRadius = dialDiameter / 2 - strokeWidth - shadowWidth;
        const handle1Angle = valueToAngle({
            value: handle1.value,
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
        const handle1Position = angleToPosition(
            { degree: handle1Angle, ...angleType },
            trackInnerRadius + strokeWidth / 2,
            dialDiameter
        );
        const handle2Position =
            handle2Angle &&
            angleToPosition(
                { degree: handle2Angle, ...angleType },
                trackInnerRadius + strokeWidth / 2,
                dialDiameter
            );

        const controllable = !disabled && Boolean(handle1.onChange);

        const createCap = () => {
            const triangleRotationArg = (endAngle - startAngle) / (maxValue - minValue)
            const triangleRotation = handle1.value * triangleRotationArg + 180

            if (capMode === "triangle") {
                return (
                    <polygon
                        points={`${handle1Position.x},${handle1Position.y - handleSize} 
             ${handle1Position.x - handleSize},${handle1Position.y + handleSize} 
             ${handle1Position.x + handleSize},${handle1Position.y + handleSize}`}
                        fill={handleColor}
                        transform={`rotate(${triangleRotation} ${handle1Position.x} ${handle1Position.y})`}
                    />
                )
            } else {
                return(
                    <circle
                        r={handleSize}
                        cx={handle1Position.x}
                        cy={handle1Position.y}
                        fill="#ffffff"
                    />
                )
            }
        }

        const step = (endAngle - startAngle) / (maxValue - minValue)
        const stepRad = ((step <= 36 ? step : step / 10) * Math.PI) / 180
        const numX = dialDiameter / 2
        const numY = numX + strokeWidth / 4
        const numR = numX - strokeWidth * 5/2
        // const numR = size - trackInnerRadius + trackWidth + shadowWidth / 2 - 1
        const numbers = []
        for (let i= endAngle; i > startAngle; i-=step) {
            numbers.push(Math.round(i / step))
        }
        console.log(numbers)

        return (
            <svg
                width={dialDiameter}
                height={dialDiameter}
                ref={this.svgRef}
                onMouseDown={onMouseDown}
                onMouseEnter={onMouseEnter}
                onClick={
                    /* TODO: be smarter about this -- for example, we could run this through our
                    calculation and determine how close we are to the arc, and use that to decide
                    if we propagate the click. */
                    (ev) => controllable && ev.stopPropagation()
                }
                // onTouchStart={this.onTouch}
                // onTouchEnd={this.onTouch}
                // onTouchMove={this.onTouch}
                // onTouchCancel={this.onTouch}

                onTouchStart={onTouch}
                onTouchEnd={onTouch}
                onTouchMove={onTouch}
                onTouchCancel={onTouch}

                style={{touchAction: "none"}}
            >

                {handle2Angle === undefined ? (
                    /* One-handle mode */
                    <React.Fragment>
                        {/* Arc Background  */}
                        <path
                            d={arcPathWithRoundedEnds({
                                startAngle: handle1Angle,
                                endAngle,
                                angleType,
                                innerRadius: trackInnerRadius,
                                thickness: strokeWidth,
                                svgSize: dialDiameter,
                                direction: angleType.direction,
                            })}
                            fill={strokeColor}
                        />
                        {/* Arc (render after background so it overlays it) */}
                        <path
                            d={arcPathWithRoundedEnds({
                                startAngle,
                                endAngle: handle1Angle,
                                angleType,
                                innerRadius: (trackInnerRadius+strokeWidth/2-arcWidth/2),
                                thickness: arcWidth,
                                svgSize: dialDiameter,
                                direction: angleType.direction,
                            })}
                            fill={arcColor}
                        />
                    </React.Fragment>
                ) : (
                    /* Two-handle mode */
                    <React.Fragment>
                        {/* Arc Background Part 1  */}
                        <path
                            d={arcPathWithRoundedEnds({
                                startAngle,
                                endAngle: handle1Angle,
                                angleType,
                                innerRadius: trackInnerRadius,
                                thickness: strokeWidth,
                                svgSize: dialDiameter,
                                direction: angleType.direction,
                            })}
                            fill={strokeColor}
                        />
                        {/* Arc Background Part 2  */}
                        <path
                            d={arcPathWithRoundedEnds({
                                startAngle: handle2Angle,
                                endAngle,
                                angleType,
                                innerRadius: trackInnerRadius,
                                thickness: strokeWidth,
                                svgSize: dialDiameter,
                                direction: angleType.direction,
                            })}
                            fill={strokeColor}
                        />
                        {/* Arc (render after background so it overlays it) */}
                        <path
                            d={arcPathWithRoundedEnds({
                                startAngle: handle1Angle,
                                endAngle: handle2Angle,
                                angleType,
                                innerRadius: trackInnerRadius,
                                thickness: strokeWidth,
                                svgSize: dialDiameter,
                                direction: angleType.direction,
                            })}
                            fill={arcColor}
                        />
                    </React.Fragment>
                )}

                {numbers.map(value => {
                    return(
                        <text key={value}
                              x={numX + (trackInnerRadius - strokeWidth / 2)*Math.sin(value*stepRad)}
                              y={numY - (trackInnerRadius - strokeWidth / 2)*Math.cos(value*stepRad)}
                              fontSize={12} fill={handleColor} textAnchor="middle">
                            {value}
                        </text>
                    )
                })}

                {numbers.map(value => {
                    return(
                        <Line key={`ticks${value}`}
                              x1={numX + (trackInnerRadius+2/3*strokeWidth)*Math.sin(value*stepRad)}
                              y1={numX - (trackInnerRadius+2/3*strokeWidth)*Math.cos(value*stepRad)}
                              x2={numX + (trackInnerRadius+strokeWidth)*Math.sin(value*stepRad)}
                              y2={numX - (trackInnerRadius+strokeWidth)*Math.cos(value*stepRad)}
                              stroke={handleColor}>
                        </Line>
                    )
                })}

                <text
                    x={dialDiameter / 2}
                    y={dialDiameter / 2 + 10}
                    fontSize={meterTextSize}
                    fill={meterTextColor}
                    textAnchor="middle"
                >
                    {meterText}  {/*TODO: text format*/}
                </text>

                {
                    /* Handle 1 */
                    controllable && (
                        <React.Fragment>
                            {createCap()}
                        </React.Fragment>
                    )
                }

                {
                    /* Handle 2 */
                    handle2Position && (
                        <React.Fragment>
                            <circle
                                r={handleSize}
                                cx={handle2Position.x}
                                cy={handle2Position.y}
                                fill="#ffffff"
                            />
                        </React.Fragment>
                    )
                }
            </svg>
        );
    }
}

export class CircularSliderWithChildren extends React.Component<
    React.PropsWithChildren<Props>
> {
    static defaultProps = CircularSlider.defaultProps;

    render() {
        const {dialDiameter} = this.props;
        return (
            <div
                style={{
                    width: dialDiameter,
                    height: dialDiameter,
                    position: "relative",
                }}
            >
                <CircularSlider {...this.props} />
                <div
                    style={{
                        position: "absolute",
                        top: "25%",
                        left: "50%",
                        transform: "translateX(-50%)",
                        display: "flex",
                        flexDirection: "column",
                        alignItems: "center",
                        justifyContent: "center",
                    }}
                >
                    {this.props.children}
                </div>
            </div>
        );
    }
}

export default CircularSlider;