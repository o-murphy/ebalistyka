import React, {useRef} from 'react';
import {View, PanResponder} from 'react-native';
import Svg, {Circle, Path, Polygon} from 'react-native-svg';
import {arcPathWithRoundedEnds} from './svgPaths';
import {
    angleToPosition,
    positionToAngle,
    AngleDescription,
    valueToAngle,
    angleToValue,
} from './circularGeometry';

type Props = {
    size: number;
    trackWidth: number;
    minValue: number;
    maxValue: number;
    startAngle: number;
    endAngle: number;
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
    arcBackgroundColor: string;
    coerceToInt?: boolean;
    outerShadow?: boolean;
    capMode?: 'circle' | 'triangle';
};

const CircularSlider: React.FC<Props> = ({
                                             size,
                                             trackWidth,
                                             minValue,
                                             maxValue,
                                             startAngle,
                                             endAngle,
                                             angleType,
                                             handleSize,
                                             handle1,
                                             handle2,
                                             onControlFinished,
                                             disabled,
                                             arcColor,
                                             arcBackgroundColor,
                                             coerceToInt,
                                             outerShadow,
                                             capMode,
                                         }: Props) => {
    const svgRef = useRef<any>(null);

    const shadowWidth = 20;
    const trackInnerRadius = size / 2 - trackWidth - shadowWidth;
    const handle1Position = angleToPosition(
        {
            degree: valueToAngle({
                value: handle1.value,
                minValue,
                maxValue,
                startAngle,
                endAngle
            }), ...angleType
        },
        trackInnerRadius + trackWidth / 2,
        size
    );

    const handle1Angle = valueToAngle({
        value: handle1.value,
        minValue,
        maxValue,
        startAngle,
        endAngle,
    });

    const controllable = !disabled && Boolean(handle1.onChange);

    const panResponder = useRef(
        PanResponder.create({
            onStartShouldSetPanResponder: () => true,
            onMoveShouldSetPanResponder: () => true,
            onPanResponderGrant: (e) => handlePanResponderGrant(e),
            onPanResponderMove: (e) => handlePanResponderMove(e),
            onPanResponderRelease: (e) => handlePanResponderRelease(),
        })
    ).current;

    const handlePanResponderGrant = (ev: any) => {
        const svgRefInstance = svgRef.current;
        if (svgRefInstance) {
            svgRefInstance.measure((_x, _y, _width, _height, _pageX, _pageY) => {
                handleMousePosition(ev, _pageX, _pageY);
            });
        }
    };

    const handlePanResponderMove = (ev: any) => {
        const x = ev.nativeEvent.pageX;
        const y = ev.nativeEvent.pageY;
        handleMousePosition(ev, x, y);
    };

    const handlePanResponderRelease = () => {
        if (onControlFinished) {
            onControlFinished();
        }
    };

    const handleMousePosition = (ev: any, x: number, y: number) => {
        const coordsInSvg = {x, y};
        const angle = positionToAngle(coordsInSvg, size, angleType);
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
                Math.abs(value - handle2.value) < Math.abs(value - handle1.value)
            ) {
                handle2.onChange(value);
            } else {
                handle1.onChange && handle1.onChange(value);
            }
        }
    };

    const createCap = () => {
        const triangleRotationArg = (endAngle - startAngle) / (maxValue - minValue);
        const triangleRotation = handle1.value * triangleRotationArg + 180;

        if (capMode === 'triangle') {
            return (
                <Polygon
                    points={`${handle1Position.x},${handle1Position.y - handleSize} 
             ${handle1Position.x - handleSize},${handle1Position.y + handleSize} 
             ${handle1Position.x + handleSize},${handle1Position.y + handleSize}`}
                    fill="#ffffff"
                    transform={`rotate(${triangleRotation} ${handle1Position.x} ${handle1Position.y})`}
                />
            );
        } else {
            return (
                <Circle
                    r={handleSize}
                    cx={handle1Position.x}
                    cy={handle1Position.y}
                    fill="#ffffff"
                />
            );
        }
    };

    // ... (remaining code remains the same)

    return (
        <View style={{width: size, height: size}}>
            <Svg
                width={size}
                height={size}
                ref={svgRef}
                {...(outerShadow ? {...panResponder.panHandlers} : {})}
            >
                {
                    /* Shadow */
                    outerShadow && (
                        <React.Fragment>
                            <radialGradient id="outerShadow">
                                <stop offset="90%" stopColor={arcColor} />
                                <stop offset="100%" stopColor="white" />
                            </radialGradient>

                            <Circle
                                fill="none"
                                stroke="url(#outerShadow)"
                                cx={size / 2}
                                cy={size / 2}
                                // Subtract an extra pixel to ensure there's never any gap between slider and shadow
                                r={trackInnerRadius + trackWidth + shadowWidth / 2 - 1}
                                strokeWidth={shadowWidth}
                            />
                        </React.Fragment>
                    )
                }

                {
                    <React.Fragment>
                        {/* Arc Background  */}
                        <Path
                            d={arcPathWithRoundedEnds({
                                startAngle: handle1Angle,
                                endAngle,
                                angleType,
                                innerRadius: trackInnerRadius,
                                thickness: trackWidth,
                                svgSize: size,
                                direction: angleType.direction,
                            })}
                            fill={arcBackgroundColor}
                        />
                        {/* Arc (render after background so it overlays it) */}
                        <Path
                            d={arcPathWithRoundedEnds({
                                startAngle,
                                endAngle: handle1Angle,
                                angleType,
                                innerRadius: trackInnerRadius,
                                thickness: trackWidth,
                                svgSize: size,
                                direction: angleType.direction,
                            })}
                            fill={arcColor}
                        />
                    </React.Fragment>
                }

                {
                    /* Handle 1 */
                    controllable && (
                        <React.Fragment>{createCap()}</React.Fragment>
                    )
                }

            </Svg>
        </View>
    );
};

export default CircularSlider;