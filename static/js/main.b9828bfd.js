(()=>{"use strict";var e={8330:(e,t,n)=>{n.r(t),n.d(t,{default:()=>Fe});var r=n(885),i=n(5004),o=n(2152),a=n(3426),l=n(6029),c=n(52),s=n(4659),u=n(1232),d=n(4327),f=n(1116),h=n(3019),g=n(1072),p=n(4953),y=n(6792),x=n(2629);function m(e){var t=e.text,n=(0,g.useTheme)(),r=y.default.create({scrollViewContainer:{backgroundColor:n.colors.background}});return(0,x.jsx)(h.default,{style:r.scrollViewContainer,keyboardShouldPersistTaps:"always",alwaysBounceVertical:!1,showsVerticalScrollIndicator:!0,contentContainerStyle:{flex:1,justifyContent:"center"},children:(0,x.jsx)(p.default,{style:{textAlign:"center"},children:t||"Not implemented yet"})})}var b=n(4942),j=n(6459),v=n(5222),O=n(8661),w=n(2306),P=n(1318);const S={grid:{grid:{flex:1},row:{flex:1,flexDirection:"row",alignItems:"center"},col:{flex:1}},card:{card:{margin:15,padding:10},content:{marginHorizontal:0,paddingHorizontal:10}},bottomBar:{backgroundColor:"aquamarine",position:"absolute",left:0,right:0,bottom:0},fab:{position:"absolute",right:16},chip:{measure:{display:"flex"},measure_text:{textAlign:"right"}},modal:{simple:{container:{display:"flex",alignSelf:"center",margin:20,padding:20},title:{textAlign:"center",marginBottom:10}}},numberPicker:{container:{position:"relative"},selectedIndicator:{position:"absolute",width:"100%",backgroundColor:"hsl(200, 8%, 94%)",borderRadius:5,top:"50%"}}};const C=function(){var e=(0,u.useSafeAreaInsets)().bottom,t=(0,g.useTheme)(),n=(0,P.useNavigation)(),o=(0,i.useState)(""),a=(0,r.default)(o,2),l=a[0],c=a[1];(0,i.useEffect)((function(){return n.addListener("state",(function(){var e,t=(null==(e=n.getCurrentRoute())?void 0:e.name)||"";c(t)}))}),[n]);return(0,x.jsxs)(O.default,{elevated:!0,style:[S.bottomBar.position,{height:80+e,backgroundColor:t.colors.elevation.level2}],safeAreaInsets:{bottom:e},children:[(0,x.jsx)(O.default.Action,{icon:"weather-partly-cloudy",onPress:function(){return n.navigate("Atmosphere")}}),(0,x.jsx)(O.default.Action,{icon:"calculator",onPress:function(){return n.navigate("Calculate")}}),(0,x.jsx)(O.default.Action,{icon:"table-large",onPress:function(){return n.navigate("Trajectory")}}),(0,x.jsx)(O.default.Action,{icon:"cog-outline",onPress:function(){return n.navigate("Settings")}}),(0,x.jsx)(w.default,{mode:"flat",size:"medium",icon:"Home"===l?"plus":"home",onPress:function(){"Home"!==l&&n.navigate("Home")},style:[S.fab,{top:12}]})]})};var k=n(9340),M="ios"===o.default.OS?"dots-horizontal":"dots-vertical";function V(e){var t=Object.assign({},((0,j.default)(e),e)),n=t.navigation,r=t.route,i=t.options,o=t.back,a=t.params,l=a.nightMode,c=a.toggleNightMode,s=(0,k.default)(i,r.name);return(0,x.jsxs)(O.default.Header,{elevated:!0,children:[o?(0,x.jsx)(O.default.BackAction,{onPress:n.goBack}):null,(0,x.jsx)(O.default.Content,{title:s}),(0,x.jsx)(O.default.Action,{icon:l?"brightness-7":"brightness-3",onPress:function(){return c(!l)}}),(0,x.jsx)(O.default.Action,{icon:M,onPress:function(){}})]})}var A=n(239),T=n(3982);const I=function(e){var t=e.children,n=e.title;return(0,x.jsxs)(T.default,{mode:"elevated",elevation:1,style:[S.card.card],children:[(0,x.jsx)(T.default.Title,{titleVariant:"titleLarge",title:n}),(0,x.jsx)(T.default.Content,{style:S.card.content,children:t})]})};var U=n(7970),D=n(582),$=n(5647),R=n(3555),E=n(9385);const z=function(e){var t=e.children,n=e.label,o=e.text,a=e.icon,l=void 0===a?null:a,c=e.onAccept,s=void 0===c?null:c,u=e.onDecline,d=void 0===u?null:u,f=i.useState(!1),h=(0,r.default)(f,2),p=h[0],y=h[1],m=function(){return y(!0)};return(0,x.jsxs)(E.default,{style:{display:"flex",justifyContent:"center"},children:[(0,x.jsx)(D.default,{icon:l,closeIcon:"square-edit-outline",style:{margin:0},textStyle:{fontSize:16},onPress:m,onClose:m,children:o}),(0,x.jsx)($.default,{children:(0,x.jsxs)(R.default,{visible:p,onDismiss:function(){y(!1)},style:{justifyContent:"center"},children:[(0,x.jsx)(R.default.Title,{children:n}),(0,x.jsx)(R.default.Content,{children:t}),(0,x.jsxs)(R.default.Actions,{children:[(0,x.jsx)(w.default,{icon:"close",mode:"flat",size:"small",onPress:function(){d&&d(),y(!1)},variant:"tertiary",color:(0,g.useTheme)().colors.tertiary}),(0,x.jsx)(w.default,{icon:"check",mode:"flat",size:"small",onPress:function(){s&&s(),y(!1)}})]})]})})]})};var F=n(2982),L=n(2532);const N=y.default.create({container:{position:"relative"},selectedIndicator:{position:"absolute",width:"100%",backgroundColor:"hsl(200, 8%, 94%)",borderRadius:5,top:"50%"},scrollView:{overflow:"hidden",flex:1},option:{alignItems:"center",justifyContent:"center",paddingHorizontal:16,zIndex:100}});var B=n(1054);const W=i.memo((function(e){var t=e.textStyle,n=e.style,r=e.height,i=e.option,o=e.index,a=e.visibleRest,l=e.currentScrollIndex,c=e.opacityFunction,s=e.rotationFunction,u=e.scaleFunction,d=L.default.subtract(o,l),f=d.interpolate({inputRange:function(){for(var e=[0],t=1;t<=a+1;t++)e.unshift(-t),e.push(t);return e}(),outputRange:function(){for(var e=[0],t=1;t<=a+1;t++){for(var n=r/2*(1-Math.sin(Math.PI/2-s(t))),i=1;i<t;i++)n+=r*(1-Math.sin(Math.PI/2-s(i)));e.unshift(n),e.push(-n)}return e}()}),h=d.interpolate({inputRange:function(){for(var e=[0],t=1;t<=a+1;t++)e.unshift(-t),e.push(t);return e}(),outputRange:function(){for(var e=[1],t=1;t<=a+1;t++){var n=c(t);e.unshift(n),e.push(n)}return e}()}),g=d.interpolate({inputRange:function(){for(var e=[0],t=1;t<=a+1;t++)e.unshift(-t),e.push(t);return e}(),outputRange:function(){for(var e=[1],t=1;t<=a+1;t++){var n=u(t);e.unshift(n),e.push(n)}return e}()}),p=d.interpolate({inputRange:function(){for(var e=[0],t=1;t<=a+1;t++)e.unshift(-t),e.push(t);return e}(),outputRange:function(){for(var e=["0deg"],t=1;t<=a+1;t++){var n=s(t);e.unshift(`${n}deg`),e.push(`${n}deg`)}return e}()});return(0,x.jsx)(L.default.View,{style:[N.option,n,{height:r,opacity:h,transform:[{translateY:f},{rotateX:p},{scale:g}]}],children:(0,x.jsx)(B.default,{style:t,children:i})})}),(function(){return!0}));function H(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function G(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?H(Object(n),!0).forEach((function(t){(0,b.default)(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):H(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}const Y=function(e){var t=e.selectedIndex,n=e.options,a=e.onChange,l=e.selectedIndicatorStyle,c=void 0===l?{}:l,s=e.containerStyle,u=void 0===s?{}:s,d=e.itemStyle,f=void 0===d?{}:d,h=e.itemTextStyle,g=void 0===h?{}:h,p=e.itemHeight,y=void 0===p?40:p,m=e.scaleFunction,b=void 0===m?function(e){return 1**e}:m,j=e.rotationFunction,v=void 0===j?function(e){return 1-Math.pow(.5,e)}:j,O=e.opacityFunction,w=void 0===O?function(e){return Math.pow(1/3,e)}:O,P=e.visibleRest,S=void 0===P?2:P,C=e.decelerationRate,k=void 0===C?"fast":C,M=e.containerProps,V=void 0===M?{}:M,A=e.flatListProps,T=void 0===A?{}:A,I=(0,i.useRef)(null),U=(0,i.useState)(new L.default.Value(0)),D=(0,r.default)(U,1)[0],$=(0,i.useRef)((new Date).getTime()),R=(1+2*S)*y,z=(0,i.useState)(t),B=(0,r.default)(z,2),H=B[0],Y=B[1],_=(0,i.useMemo)((function(){for(var e=(0,F.default)(n),t=0;t<S;t++)e.unshift(null),e.push(null);return e}),[n,S]),q=(0,i.useMemo)((function(){return(0,F.default)(Array(_.length)).map((function(e,t){return t*y}))}),[_,y]),X=(0,i.useMemo)((function(){return L.default.add(L.default.divide(D,y),S)}),[S,D,y]);(0,i.useEffect)((function(){if(t<0||t>=n.length)throw new Error(`Selected index ${t} is out of bounds [0, ${n.length-1}]`)}),[t,n]),(0,i.useEffect)((function(){var e;null==(e=I.current)||e.scrollToIndex({index:t,animated:!1})}),[t]),(0,i.useEffect)((function(){if("web"===o.default.OS){var e=setInterval((function(){var e;(new Date).getTime()-$.current>500&&(null==(e=I.current)||e.scrollToIndex({index:H,animated:!0}))}),100);return function(){clearInterval(e)}}}),[H]),(0,i.useEffect)((function(){"web"===o.default.OS&&a(H)}),[H,a]);return(0,x.jsxs)(E.default,G(G({style:[N.container,{height:R},u]},V),{},{children:[(0,x.jsx)(E.default,{style:[N.selectedIndicator,c,{transform:[{translateY:-y/2}],height:y}]}),(0,x.jsx)(L.default.FlatList,G(G({},T),{},{ref:I,style:N.scrollView,showsVerticalScrollIndicator:!1,onScroll:L.default.event([{nativeEvent:{contentOffset:{y:D}}}],{useNativeDriver:!0,listener:function(e){return function(e){if("web"===o.default.OS){var t=e.nativeEvent.contentOffset.y,n=Math.round(t/y);Y(n),$.current=(new Date).getTime()}}(e)}}),onMomentumScrollEnd:function(e){var r=Math.min(y*(n.length-1),Math.max(e.nativeEvent.contentOffset.y,0)),i=Math.floor(Math.floor(r)/y);Math.floor(r%y)>y/2&&i++,i!==t&&a(i)},snapToOffsets:q,decelerationRate:k,initialScrollIndex:t,getItemLayout:function(e,t){return{length:y,offset:y*t,index:t}},data:_,keyExtractor:function(e,t){return t.toString()},renderItem:function(e){var t=e.item,n=e.index;return(0,x.jsx)(W,{index:n,option:t,style:f,textStyle:g,height:y,currentScrollIndex:X,scaleFunction:b,rotationFunction:v,opacityFunction:w,visibleRest:S},`option-${n}`)}}))]}))};function _(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function q(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?_(Object(n),!0).forEach((function(t){(0,b.default)(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):_(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}var X=function(e){for(var t=Object.assign({},((0,j.default)(e),e)),n=t.curValue,r=t.minValue,i=t.maxValue,o=t.onChange,a=t.wheelProps,l=[],c=Math.floor(r);c<=Math.floor(i);c++)l.push(c);return(0,x.jsx)(Y,q(q({},a),{},{selectedIndex:l.indexOf(n),options:l.map((function(e){return`${e}`})),onChange:function(e){o(l[e])}}))},J=function(e){var t=Object.assign({},((0,j.default)(e),e)),n=t.curValue,r=t.decimals,i=t.onChange,o=t.wheelProps,a=function(e){return(e%1).toFixed(r).slice(1)},l=1/10**r,c=function(){for(var e=[],t=0;t<1;t+=l)e.push(a(t));return e}();return(0,x.jsx)(Y,q(q({},o),{},{selectedIndex:c.indexOf(a(n)),options:c,onChange:function(e){i(parseFloat(c[e]))}}))};function Z(e){var t=Object.assign({},((0,j.default)(e),e)),n=t.curValue,o=(t.minValue,t.maxValue,t.decimals,t.onChange),a=(0,g.useTheme)(),l={selectedIndicatorStyle:q(q({},S.numberPicker.selectedIndicator),{},{borderRadius:0,backgroundColor:a.colors.onSecondary}),itemTextStyle:{color:a.colors.secondary,fontWeight:"bold",fontSize:24},containerStyle:q(q({},S.numberPicker.container),{},{backgroundColor:a.colors.secondaryContainer,marginTop:10})},c=q(q({},l),{},{containerStyle:q(q({},l.containerStyle),{},{borderTopLeftRadius:24,borderBottomLeftRadius:24}),itemStyle:{marginLeft:"auto",marginRight:0,paddingRight:5}}),s=q(q({},l),{},{containerStyle:q(q({},l.containerStyle),{},{borderTopRightRadius:24,borderBottomRightRadius:24}),itemStyle:{marginLeft:0,marginRight:"auto",paddingLeft:5}}),u=(0,i.useState)(Math.floor(n)),d=(0,r.default)(u,2),f=d[0],h=d[1],p=(0,i.useState)(n%1),y=(0,r.default)(p,2),m=y[0],b=y[1],v=function(e){o&&o(e+m)};return(0,x.jsxs)(E.default,{style:{flexDirection:"row",justifyContent:"center"},children:[(0,x.jsx)(X,q(q({wheelProps:c},q(q({},t),{},{curValue:f})),{},{onChange:function(e){h(e),v(e+m)}})),(0,x.jsx)(J,q(q({wheelProps:s},q(q({},t),{},{curValue:m})),{},{onChange:function(e){b(e),v(e+f)}}))]})}function K(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function Q(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?K(Object(n),!0).forEach((function(t){(0,b.default)(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):K(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function ee(e){for(var t=Object.assign({},((0,j.default)(e),e)),n=t.maxValue,r=t.minValue,i=t.onChange,o=t.curValue,a=(0,g.useTheme)(),l=[],c=r;c<=n;c++)l.push(c);var s={selectedIndicatorStyle:Q(Q({},S.numberPicker.selectedIndicator),{},{borderRadius:0,backgroundColor:a.colors.onSecondary}),containerStyle:Q(Q({},S.numberPicker.container),{},{backgroundColor:a.colors.secondaryContainer,borderRadius:24,marginTop:10}),itemTextStyle:{color:a.colors.secondary,fontWeight:"bold",fontSize:24}};return(0,x.jsx)(E.default,{style:{flexDirection:"row",justifyContent:"center"},children:(0,x.jsx)(Y,Q(Q({},s),{},{selectedIndex:l.indexOf(o),options:l,onChange:function(e){i&&i(l[e])}}))})}function te(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function ne(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?te(Object(n),!0).forEach((function(t){(0,b.default)(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):te(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function re(e){var t=e.field,n=(0,i.useState)(t.initialValue),o=(0,r.default)(n,2),a=o[0],l=o[1],c=(0,i.useState)(a),s=(0,r.default)(c,2),u=s[0],d=s[1],f=ne(ne({},t),{},{curValue:a,onChange:d}),h="int"===t.mode?(0,x.jsx)(ee,ne({},f)):(0,x.jsx)(Z,ne({},f));return(0,x.jsxs)(A.Row,{style:S.grid.row,children:[(0,x.jsx)(A.Col,{size:8,children:(0,x.jsx)(p.default,{style:{fontSize:16},children:t.label})}),(0,x.jsx)(A.Col,{size:8,children:(0,x.jsx)(z,{icon:t.icon,label:`${t.label}, ${t.suffix}`,text:`${a.toFixed(t.decimals)} ${t.suffix}`,onAccept:function(){l(u)},onDecline:function(){d(u)},children:h})})]})}function ie(){var e=[{key:"temp",label:"Temperature",suffix:U.UnitProps[U.Unit.Celsius].symbol,icon:"thermometer",mode:"int",initialValue:15,maxValue:50,minValue:-50,decimals:0},{key:"pressure",label:"Pressure",suffix:U.UnitProps[U.Unit.MmHg].symbol,icon:"speedometer",mode:"int",initialValue:760,maxValue:1e3,minValue:700,decimals:0},{key:"humidity",label:"Humidity",suffix:"%",icon:"water",mode:"int",initialValue:78,maxValue:100,minValue:0,decimals:0},{key:"altitude",label:"Altitude",suffix:U.UnitProps[U.Unit.Meter].symbol,icon:"ruler",mode:"int",initialValue:150,maxValue:3e3,minValue:0,decimals:0}];return(0,x.jsx)(I,{title:"Current atmosphere",children:(0,x.jsx)(A.Grid,{style:S.grid.grid,children:e.map((function(e){return(0,x.jsx)(re,{field:e},e.key)}))})})}var oe=n(2557);function ae(e){var t=e.initialValue,n=e.onChange,o=e.items,a=(0,i.useState)(t),l=(0,r.default)(a,2),c=l[0],s=l[1];return(0,x.jsx)(oe.default.Group,{onValueChange:function(e){s(e),n&&n(e)},value:c,children:o.map((function(e){return(0,x.jsx)(oe.default.Item,{label:e.label,value:e.value},e.value)}))})}const le=function(e){var t=e.children,n=e.title,o=e.text,a=e.icon,l=void 0===a?null:a,c=e.onAccept,s=void 0===c?null:c,u=e.onDecline,d=void 0===u?null:u,f=i.useState(!1),p=(0,r.default)(f,2),y=p[0],m=p[1],b=function(){return m(!0)};return(0,x.jsxs)(E.default,{style:{display:"flex",justifyContent:"center"},children:[(0,x.jsx)(D.default,{icon:l,closeIcon:"square-edit-outline",style:{margin:0},textStyle:{fontSize:16},onPress:b,onClose:b,children:o}),(0,x.jsx)($.default,{children:(0,x.jsxs)(R.default,{visible:y,onDismiss:function(){m(!1)},style:{justifyContent:"center"},children:[(0,x.jsx)(R.default.Title,{children:n}),(0,x.jsx)(R.default.ScrollArea,{children:(0,x.jsx)(h.default,{contentContainerStyle:{padding:24},children:t})}),(0,x.jsxs)(R.default.Actions,{children:[(0,x.jsx)(w.default,{icon:"close",mode:"flat",size:"small",onPress:function(){d&&d(),m(!1)},variant:"tertiary",color:(0,g.useTheme)().colors.tertiary}),(0,x.jsx)(w.default,{icon:"check",mode:"flat",size:"small",onPress:function(){s&&s(),m(!1)}})]})]})})]})};n(8822);function ce(){var e=(0,i.useState)("EN"),t=(0,r.default)(e,2),n=t[0],o=t[1],a=(0,i.useState)(n),l=(0,r.default)(a,2),c=l[0],s=l[1];return(0,x.jsx)(I,{title:"General",children:(0,x.jsx)(A.Grid,{style:S.grid.grid,children:(0,x.jsxs)(A.Row,{style:S.grid.row,children:[(0,x.jsx)(A.Col,{size:9,children:(0,x.jsx)(p.default,{style:{fontSize:16},children:"Language"})}),(0,x.jsx)(A.Col,{size:7,children:(0,x.jsx)(le,{title:"Language",text:n,icon:"translate",onAccept:function(){o(c)},onDecline:function(){s(n)},children:(0,x.jsx)(ae,{initialValue:c,onChange:s,items:[{label:"English",value:"EN",key:"EN"},{label:"Ukrainian",value:"UA",key:"UA"}]})})})]})})})}var se=function(e){return Object.keys(e).map((function(t){return{label:U.UnitProps[e[t]].name,value:e[t]}}))},ue=[{key:"distance",label:"Distance",list:[{label:U.UnitProps[U.Unit.Meter].name,value:U.Unit.Meter},{label:U.UnitProps[U.Unit.Foot].name,value:U.Unit.Foot},{label:U.UnitProps[U.Unit.Yard].name,value:U.Unit.Yard}],def:U.Unit.Meter},{key:"velocity",label:"Velocity",list:[{label:U.UnitProps[U.Unit.MPS].name,value:U.Unit.MPS},{label:U.UnitProps[U.Unit.FPS].name,value:U.Unit.FPS}],def:U.Unit.MPS},{key:"angular",label:"Angular",list:se(U.Measure.Angular),def:U.Unit.Degree},{key:"sizes",label:"Sizes",list:[{label:U.UnitProps[U.Unit.Inch].name,value:U.Unit.Inch},{label:U.UnitProps[U.Unit.Millimeter].name,value:U.Unit.Millimeter},{label:U.UnitProps[U.Unit.Centimeter].name,value:U.Unit.Centimeter},{label:U.UnitProps[U.Unit.Centimeter].name,value:U.Unit.Line}],def:U.Unit.Inch},{key:"weight",label:"Weight",list:se(U.Measure.Weight),def:U.Unit.Grain},{key:"temperature",label:"Temperature",list:[{label:U.UnitProps[U.Unit.Celsius].name,value:U.Unit.Celsius},{label:U.UnitProps[U.Unit.Fahrenheit].name,value:U.Unit.Fahrenheit}],def:U.Unit.Celsius},{key:"pressure",label:"Pressure",list:se(U.Measure.Pressure),def:U.Unit.PSI},{key:"energy",label:"Energy",list:se(U.Measure.Energy),def:U.Unit.Joule},{key:"adjustment",label:"Adjustment",list:se(U.Measure.Angular),def:U.Unit.MIL}];function de(){var e=function(e){var t=e.field,n=(0,i.useState)(t.def),o=(0,r.default)(n,2),a=o[0],l=o[1],c=(0,i.useState)(a),s=(0,r.default)(c,2),u=s[0],d=s[1];return(0,x.jsxs)(A.Row,{style:S.grid.row,children:[(0,x.jsx)(A.Col,{size:9,children:(0,x.jsx)(p.default,{style:{fontSize:16},children:t.label})}),(0,x.jsx)(A.Col,{size:7,children:(0,x.jsx)(le,{title:t.label,text:U.UnitProps[a].name,onAccept:function(){l(u)},children:(0,x.jsx)(ae,{initialValue:a,onChange:d,items:t.list})})})]},t.key)};return(0,x.jsx)(I,{title:"Units of measurement",children:(0,x.jsx)(A.Grid,{style:S.grid.grid,children:ue.map((function(t){return(0,x.jsx)(e,{field:t},t.key)}))})})}var fe=n(5783),he=n(2193);function ge(){var e=(0,g.useTheme)(),t=[{value:"Right",label:"Right",icon:"rotate-right",showSelectedCheck:!0,checkedColor:e.colors.primary},{value:"Left",label:"Left",icon:"rotate-left",showSelectedCheck:!0,checkedColor:e.colors.primary}],n=(0,i.useState)("Right"),o=(0,r.default)(n,2),a=o[0],l=o[1],c=(0,i.useState)(a),s=(0,r.default)(c,2),u=s[0],d=s[1],f=i.useState("My rifle"),h=(0,r.default)(f,2),y=h[0],m=h[1],b=i.useState(y),j=(0,r.default)(b,2),v=j[0],O=j[1];return(0,x.jsxs)(I,{title:"Weapon",children:[(0,x.jsx)(z,{label:"Name",icon:"card-bulleted-outline",text:y,onAccept:function(){m(v)},onDecline:function(){O(y)},children:(0,x.jsx)(fe.default,{value:v,onChangeText:O})}),(0,x.jsxs)(A.Grid,{style:S.grid.grid,children:[[{key:"diameter",label:"Diameter",suffix:"in",icon:"diameter-variant",mode:"float",initialValue:.308,maxValue:22,minValue:.001,decimals:3},{key:"twist",label:"Twist",suffix:"in",icon:"screw-flat-top",mode:"float",initialValue:11,maxValue:20,minValue:-20,decimals:2}].map((function(e){return(0,x.jsx)(re,{field:e},e.key)})),(0,x.jsxs)(A.Row,{style:S.grid.row,children:[(0,x.jsx)(A.Col,{size:8,children:(0,x.jsx)(p.default,{style:{fontSize:16},children:"Twist direction"})}),(0,x.jsx)(A.Col,{size:8,children:(0,x.jsx)(z,{label:"Twist",icon:"Right"===a?"rotate-right":"rotate-left",text:a,onAccept:function(){l(u)},children:(0,x.jsx)(he.default,{buttons:t,value:u,onValueChange:d})})})]})]})]})}function pe(e){var t=e.value,n=e.minValue,r=e.maxValue,i=e.startAngle,o=e.endAngle;if(o<=i)throw new Error("endAngle must be greater than startAngle");return(t-n)/(r-n)*(o-i)+i}function ye(e,t,n){if(n=n||{direction:"ccw",axis:"+x"},t.direction!==n.direction&&(e=0===e?0:360-e),t.axis===n.axis)return e;if(t.axis[1]===n.axis[1])return(180+e)%360;switch(n.direction+t.axis+n.axis){case"ccw+x-y":case"ccw-x+y":case"ccw+y+x":case"ccw-y-x":case"cw+y-x":case"cw-y+x":case"cw-x-y":case"cw+x+y":return(90+e)%360;case"ccw+y-x":case"ccw-y+x":case"ccw+x+y":case"ccw-x-y":case"cw+x-y":case"cw-x+y":case"cw+y+x":case"cw-y-x":return(270+e)%360;default:throw new Error("Unhandled conversion")}}function xe(e,t,n){var r,i,o=ye(e.degree,e,{direction:"ccw",axis:"+x"})/180*Math.PI;return o<=Math.PI?o<=Math.PI/2?(i=Math.sin(o)*t,r=Math.cos(o)*t):(i=Math.sin(Math.PI-o)*t,r=Math.cos(Math.PI-o)*t*-1):o<=1.5*Math.PI?(i=Math.sin(o-Math.PI)*t*-1,r=Math.cos(o-Math.PI)*t*-1):(i=Math.sin(2*Math.PI-o)*t*-1,r=Math.cos(2*Math.PI-o)*t),{x:r+n/2,y:n/2-i}}function me(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function be(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?me(Object(n),!0).forEach((function(t){(0,b.default)(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):me(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function je(e){var t=e.startAngle,n=e.innerRadius,r=e.thickness,i=e.direction,o=e.angleType,a=e.svgSize,l=e.endAngle;t%360===l%360&&t!==l&&(l-=.001);var c=l-t>=180,s=n+r,u=xe(be({degree:t},o),n,a),d=`\n    M ${u.x},${u.y}\n  `,f=xe(be({degree:l},o),n,a),h=`\n    A ${n} ${n} 0\n      ${c?"1":"0"}\n      ${"cw"===i?"1":"0"}\n      ${f.x} ${f.y}\n  `,g=xe(be({degree:l},o),s,a),p=`\n    A ${r/2} ${r/2} 0\n      ${c?"1":"0"}\n      ${"cw"===i?"0":"1"}\n      ${g.x} ${g.y}\n  `,y=xe(be({degree:t},o),s,a);return d+h+p+`\n    A ${s} ${s} 0\n      ${c?"1":"0"}\n      ${"cw"===i?"0":"1"}\n      ${y.x} ${y.y}\n  `+`\n    A ${r/2} ${r/2} 0\n      ${c?"1":"0"}\n      ${"cw"===i?"0":"1"}\n      ${u.x} ${u.y}\n  `+" Z"}var ve=n(4710);function Oe(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function we(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?Oe(Object(n),!0).forEach((function(t){(0,b.default)(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):Oe(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function Pe(e){for(var t=Object.assign({},((0,j.default)(e),e)),n=t.dialDiameter,r=void 0===n?200:n,a=t.strokeWidth,l=void 0===a?4:a,c=t.value,s=t.onChange,u=t.handle2,d=t.handleSize,f=void 0===d?8:d,h=t.maxValue,g=void 0===h?0:h,p=t.minValue,y=void 0===p?360:p,m=t.startAngle,b=void 0===m?0:m,v=t.endAngle,O=void 0===v?360:v,w=t.angleType,P=void 0===w?{direction:"cw",axis:"-y"}:w,S=t.disabled,C=t.arcColor,k=void 0===C?"#0cd":C,M=t.strokeColor,V=void 0===M?"#aaa":M,A=t.handleMode,T=void 0===A?"triangle":A,I=t.handleColor,U=void 0===I?"#0cd":I,D=t.arcWidth,$=void 0===D?10:D,R=t.meterText,E=void 0===R?"None":R,z=t.meterTextColor,F=void 0===z?"#0cd":z,L=t.meterTextSize,N=void 0===L?10:L,B=t.coerceToInt,W=void 0!==B&&B,H=t.onControlFinished,G=function(e){if(s){var t=e.nativeEvent;if(!(t.touches.length>1||"touchend"===t.type&&t.touches.length>0)){var n,r;if("web"===o.default.OS){var i=e.currentTarget.getBoundingClientRect(),a=t.changedTouches[0];n=a.clientX-i.left,r=a.clientY-i.top}else n=t.locationX,r=t.locationY;Y(n,r),"touchend"!==t.type&&"touchcancel"!==t.type||H&&H()}}},Y=function(e,t){var n=function(e,t,n){var r=e.x-t/2,i=t/2-e.y,o=Math.atan2(i,r);return o<0&&(o+=2*Math.PI),ye(o/Math.PI*180,{direction:"ccw",axis:"+x"},n)}({x:e,y:t},r,P),i=function(e){var t=e.angle,n=e.minValue,r=e.maxValue,i=e.startAngle,o=e.endAngle;if(o<=i)throw new Error("endAngle must be greater than startAngle");return t<i?n:t>o?r:(t-i)/(o-i)*(r-n)+n}({angle:n,minValue:y,maxValue:g,startAngle:b,endAngle:O});W&&(i=Math.round(i)),S||(u&&u.onChange&&Math.abs(i-u.value)<Math.abs(i-c)?u.onChange(i):s(i))},_=r/2-l,q=pe({value:c,minValue:y,maxValue:g,startAngle:b,endAngle:O}),X=u&&pe({value:u.value,minValue:y,maxValue:g,startAngle:b,endAngle:O}),J=xe(we({degree:q},P),_+l/2,r),Z=X&&xe(we({degree:X},P),_+l/2,r),K=!S&&Boolean(s),Q=function(e){var t=c*ee+180;return"triangle"===T?(0,x.jsx)(ve.Polygon,{points:`${e.x},${e.y-f} \n             ${e.x-f},${e.y+f} \n             ${e.x+f},${e.y+f}`,fill:U,transform:`rotate(${t} ${e.x} ${e.y})`}):(0,x.jsx)(ve.Circle,{r:f,cx:e.x,cy:e.y,fill:U})},ee=(O-b)/(g-y),te=(ee<=36?ee:ee/10)*Math.PI/180,ne=r/2,re=ne+l/4,ie=[],oe=O;oe>b;oe-=ee)ie.push(Math.round(oe/ee));var ae={width:r,height:r,onClick:function(e){return K&&e.stopPropagation()},onTouchStart:G,onTouchEnd:G,onTouchMove:G,onTouchCancel:G,style:{touchAction:"none"}},le={x:r/2,y:r/2+10,fontSize:N,fill:F,textAnchor:"middle"},ce={svgSize:r,direction:P.direction,angleType:P},se=we({innerRadius:_,thickness:l},ce),ue=we({innerRadius:_+l/2-$/2,thickness:$},ce);return(0,x.jsxs)(ve.default,we(we({},ae),{},{children:[void 0===X?(0,x.jsxs)(i.Fragment,{children:[(0,x.jsx)(ve.Path,{d:je(we({startAngle:q,endAngle:O},se)),fill:V}),(0,x.jsx)(ve.Path,{d:je(we({startAngle:b,endAngle:q},ue)),fill:k})]}):(0,x.jsxs)(i.Fragment,{children:[(0,x.jsx)(ve.Path,{d:je(we({startAngle:b,endAngle:q},se)),fill:V}),(0,x.jsx)(ve.Path,{d:je(we({startAngle:X,endAngle:O},se)),fill:V}),(0,x.jsx)(ve.Path,{d:je(we({startAngle:q,endAngle:X},ue)),fill:k})]}),(0,x.jsx)(ve.Text,we(we({},le),{},{children:E})),ie.map((function(e){return(0,x.jsx)(ve.Line,we({},function(e){var t=Math.sin(e*te),n=Math.cos(e*te);return{key:`ticks${e}`,x1:ne+(_+2/3*l)*t,y1:ne-(_+2/3*l)*n,x2:ne+(_+l)*t,y2:ne-(_+l)*n,stroke:U}}(e)))})),ie.map((function(e){return(0,x.jsx)(ve.Text,we(we({},function(e){var t=Math.sin(e*te),n=Math.cos(e*te);return{key:e,x:ne+(_-l/2)*t,y:re-(_-l/2)*n,fontSize:12,fill:U,textAnchor:"middle"}}(e)),{},{children:e}))})),K&&(0,x.jsx)(i.Fragment,{children:Q(J)}),Z&&(0,x.jsx)(i.Fragment,{children:Q(Z)})]}))}function Se(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function Ce(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?Se(Object(n),!0).forEach((function(t){(0,b.default)(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):Se(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function ke(e){var t=e.value,n=e.onChange,r=(0,g.useTheme)(),i={container:{justifyContent:"center",alignItems:"center",paddingBottom:40},text:{marginTop:-110,fontWeight:"bold",fontSize:16,textAlign:"center"},slider:{padding:5}},o={coerceToInt:!0,capMode:"triangle",handleSize:10,arcWidth:20,strokeWidth:20,meterTextSize:20,handleColor:r.colors.outline,arcColor:r.colors.secondaryContainer,strokeColor:r.colors.secondaryContainer,meterTextColor:r.colors.outline},a={minValue:0,maxValue:12,meterText:`${30*t}\xb0 (${t}h)`},l={value:t,onChange:n};return(0,x.jsx)(E.default,{style:i.container,children:(0,x.jsx)(Pe,Ce(Ce(Ce(Ce({},l),o),a),{},{style:i.slider,dialDiameter:240,angleType:{direction:"cw",axis:"+y"}}))})}function Me(){var e=[{key:"windSpeed",label:"Wind speed",suffix:U.UnitProps[U.Unit.MPS].symbol,icon:"windsock",mode:"float",initialValue:0,maxValue:100,minValue:0,decimals:1}],t=(0,i.useState)(0),n=(0,r.default)(t,2),o=n[0],a=n[1],l=(0,i.useState)(o/30),c=(0,r.default)(l,2),s=c[0],u=c[1];return(0,x.jsx)(I,{title:"Current wind",children:(0,x.jsxs)(A.Grid,{style:S.grid.grid,children:[e.map((function(e){return(0,x.jsx)(re,{field:e},e.key)})),(0,x.jsxs)(A.Row,{style:S.grid.row,children:[(0,x.jsx)(A.Col,{children:(0,x.jsx)(p.default,{style:{fontSize:16},children:"Wind direction"})}),(0,x.jsx)(A.Col,{children:(0,x.jsx)(z,{label:"Wind direction, degree",text:`${o}\xb0 (${o/30}h)`,icon:function(){switch(o/30){case 12:case 0:return"clock-time-twelve-outline";case 11:return"clock-time-eleven-outline";case 10:return"clock-time-ten-outline";case 9:return"clock-time-nine-outline";case 8:return"clock-time-eight-outline";case 7:return"clock-time-seven-outline";case 6:return"clock-time-six-outline";case 5:return"clock-time-five-outline";case 4:return"clock-time-four-outline";case 3:return"clock-time-three-outline";case 2:return"clock-time-two-outline";case 1:return"clock-time-one-outline"}}(),onAccept:function(){a(30*s)},onDecline:function(){u(o/30)},children:(0,x.jsx)(ke,{value:s,onChange:function(e){u(12===e?0:e)}})})})]})]})})}n(6267);function Ve(e){e.navigation;var t=(0,g.useTheme)(),n=y.default.create({scrollViewContainer:{backgroundColor:t.colors.background}});return(0,x.jsx)(x.Fragment,{children:(0,x.jsx)(h.default,{style:n.scrollViewContainer,keyboardShouldPersistTaps:"always",alwaysBounceVertical:!1,showsVerticalScrollIndicator:!0,children:(0,x.jsx)(ge,{})})})}function Ae(e){e.navigation;var t=(0,g.useTheme)(),n=y.default.create({scrollViewContainer:{backgroundColor:t.colors.background}});return(0,x.jsxs)(h.default,{style:n.scrollViewContainer,keyboardShouldPersistTaps:"always",alwaysBounceVertical:!1,showsVerticalScrollIndicator:!0,children:[(0,x.jsx)(ie,{}),(0,x.jsx)(Me,{})]})}function Te(e){e.props;var t={scrollViewContainer:{backgroundColor:(0,g.useTheme)().colors.background}};return(0,x.jsxs)(h.default,{style:t.scrollViewContainer,keyboardShouldPersistTaps:"always",alwaysBounceVertical:!1,showsVerticalScrollIndicator:!0,children:[(0,x.jsx)(ce,{}),(0,x.jsx)(de,{})]})}function Ie(e){e.navigation;return(0,x.jsx)(m,{text:"Calculator\nnot implemented yet"})}function Ue(e){e.navigation;return(0,x.jsx)(m,{text:"Trajectory table\nnot implemented yet"})}var De=(0,P.createNavigationContainerRef)();function $e(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function Re(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?$e(Object(n),!0).forEach((function(t){(0,b.default)(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):$e(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}var Ee=(0,d.default)();function ze(e){var t=Object.assign({},((0,j.default)(e),e)),n=t.nightMode,r=t.toggleNightMode;return(0,x.jsxs)(v.default,{ref:De,children:[(0,x.jsxs)(Ee.Navigator,{initialRouteName:"Home",screenOptions:{header:function(e){return(0,x.jsx)(V,Re(Re({},e),{},{params:{nightMode:n,toggleNightMode:r}}))}},children:[(0,x.jsx)(Ee.Screen,{name:"Home",component:Ve}),(0,x.jsx)(Ee.Screen,{name:"Atmosphere",component:Ae}),(0,x.jsx)(Ee.Screen,{name:"Calculate",component:Ie}),(0,x.jsx)(Ee.Screen,{name:"Trajectory",component:Ue}),(0,x.jsx)(Ee.Screen,{name:"Settings",component:Te})]}),(0,x.jsx)(C,{})]})}(0,d.default)();function Fe(){var e=(0,i.useState)(!0),t=(0,r.default)(e,2),n=t[0],d=t[1],h=n?l.MD3DarkTheme:c.MD3LightTheme,g={provider:{flex:1,backgroundColor:h.colors.background}};return"web"!==o.default.OS||f.isMobile?(0,x.jsx)(u.SafeAreaProvider,{style:g.provider,children:(0,x.jsxs)(s.default,{theme:h,children:[(0,x.jsx)(ze,{nightMode:n,toggleNightMode:function(){d((function(e){return!e}))}}),(0,x.jsx)(a.default,{style:"auto"})]})}):(0,x.jsx)(m,{text:"Oops! The app supports only mobile view"})}}},t={};function n(r){var i=t[r];if(void 0!==i)return i.exports;var o=t[r]={exports:{}};return e[r].call(o.exports,o,o.exports,n),o.exports}n.m=e,n.amdO={},(()=>{var e=[];n.O=(t,r,i,o)=>{if(!r){var a=1/0;for(u=0;u<e.length;u++){for(var[r,i,o]=e[u],l=!0,c=0;c<r.length;c++)(!1&o||a>=o)&&Object.keys(n.O).every((e=>n.O[e](r[c])))?r.splice(c--,1):(l=!1,o<a&&(a=o));if(l){e.splice(u--,1);var s=i();void 0!==s&&(t=s)}}return t}o=o||0;for(var u=e.length;u>0&&e[u-1][2]>o;u--)e[u]=e[u-1];e[u]=[r,i,o]}})(),n.n=e=>{var t=e&&e.__esModule?()=>e.default:()=>e;return n.d(t,{a:t}),t},n.d=(e,t)=>{for(var r in t)n.o(t,r)&&!n.o(e,r)&&Object.defineProperty(e,r,{enumerable:!0,get:t[r]})},n.g=function(){if("object"===typeof globalThis)return globalThis;try{return this||new Function("return this")()}catch(e){if("object"===typeof window)return window}}(),n.o=(e,t)=>Object.prototype.hasOwnProperty.call(e,t),n.r=e=>{"undefined"!==typeof Symbol&&Symbol.toStringTag&&Object.defineProperty(e,Symbol.toStringTag,{value:"Module"}),Object.defineProperty(e,"__esModule",{value:!0})},n.p="/ebalistyka/",(()=>{var e={179:0};n.O.j=t=>0===e[t];var t=(t,r)=>{var i,o,[a,l,c]=r,s=0;if(a.some((t=>0!==e[t]))){for(i in l)n.o(l,i)&&(n.m[i]=l[i]);if(c)var u=c(n)}for(t&&t(r);s<a.length;s++)o=a[s],n.o(e,o)&&e[o]&&e[o][0](),e[o]=0;return n.O(u)},r=self.webpackChunkweb=self.webpackChunkweb||[];r.forEach(t.bind(null,0)),r.push=t.bind(null,r.push.bind(r))})();var r=n.O(void 0,[108],(()=>n(6271)));r=n.O(r)})();
//# sourceMappingURL=main.b9828bfd.js.map