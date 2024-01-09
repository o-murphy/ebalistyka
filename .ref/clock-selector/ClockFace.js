// import React, { PureComponent } from 'react';
// import { Svg, G, Circle, Text, Line } from 'react-native-svg';
// import range from 'lodash.range';
// import PropTypes from 'prop-types';


// export default class ClockFace extends PureComponent {
//
//     static propTypes = {
//         r: PropTypes.number,
//         stroke: PropTypes.string,
//     }
//
//     render() {
//         const { r, stroke } = this.props;
//         const faceRadius = r - 5;
//         const textRadius = r - 26;
//
//         return (
//             <G>
//                 {
//                     range(96).map(i => {
//                         const cos = Math.cos(2 * Math.PI / 96 * i);
//                         const sin = Math.sin(2 * Math.PI / 96 * i);
//
//                         return (
//                             <Line
//                                 key={i}
//                                 stroke={stroke}
//                                 strokeWidth={i % 4 === 0 ? 3 : 1}
//                                 x1={cos * faceRadius}
//                                 y1={sin * faceRadius}
//                                 x2={cos * (faceRadius - 7)}
//                                 y2={sin * (faceRadius - 7)}
//                             />
//                         );
//                     })
//                 }
//                 <G transform={{translate: "0, -9"}}>
//                     {
//                         range(24).map((h, i) => {
//                             if (h >= 12) {
//                                 h = h - 12;
//                             }
//
//                             return (
//                                 <Text
//                                     key={i}
//                                     fill={stroke}
//                                     fontSize="12"
//                                     textAnchor="middle"
//                                     x={textRadius * Math.cos(2 * Math.PI / 24 * i - Math.PI / 2 + Math.PI / 12)}
//                                     y={textRadius * Math.sin(2 * Math.PI / 24 * i - Math.PI / 2 + Math.PI / 12)}
//                                 >
//                                     {h + 1}
//                                 </Text>
//                             )
//                         })
//                     }
//                 </G>
//             </G>
//         );
//     }
// }


import React from 'react';
import { G, Line, Text } from 'react-native-svg';
import range from 'lodash.range';
import PropTypes from 'prop-types';

const ClockFace = ({ r, stroke }) => {
    const faceRadius = r - 5;
    const textRadius = r - 26;

    return (
        <G>
            {range(96).map((i) => {
                const cos = Math.cos((2 * Math.PI * i) / 96);
                const sin = Math.sin((2 * Math.PI * i) / 96);

                return (
                    <Line
                        key={i}
                        stroke={stroke}
                        strokeWidth={i % 4 === 0 ? 3 : 1}
                        x1={cos * faceRadius}
                        y1={sin * faceRadius}
                        x2={cos * (faceRadius - 7)}
                        y2={sin * (faceRadius - 7)}
                    />
                );
            })}
            <G transform={{ translate: '0, -9' }}>
                {range(24).map((h, i) => {
                    const adjustedHour = h >= 12 ? h - 12 : h;

                    return (
                        <Text
                            key={i}
                            fill={stroke}
                            fontSize="12"
                            textAnchor="middle"
                            x={textRadius * Math.cos((2 * Math.PI * i) / 24 - Math.PI / 2 + Math.PI / 12)}
                            y={textRadius * Math.sin((2 * Math.PI * i) / 24 - Math.PI / 2 + Math.PI / 12)}
                        >
                            {adjustedHour + 1}
                        </Text>
                    );
                })}
            </G>
        </G>
    );
};

ClockFace.propTypes = {
    r: PropTypes.number,
    stroke: PropTypes.string,
};

export default ClockFace;
