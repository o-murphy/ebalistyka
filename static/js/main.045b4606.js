(()=>{"use strict";var e={9515:(e,t,n)=>{n.r(t),n.d(t,{default:()=>Be});var r=n(885),i=n(5004),o=n(2152),a=n(3426),l=n(6029),c=n(52),s=n(4659),u=n(1232),d=n(4327),f=n(1116),h=n(3019),p=n(1072),g=n(4953),y=n(6792),x=n(2629);function m(e){var t=e.text,n=(0,p.useTheme)(),r=y.default.create({scrollViewContainer:{backgroundColor:n.colors.background}});return(0,x.jsx)(h.default,{style:r.scrollViewContainer,keyboardShouldPersistTaps:"always",alwaysBounceVertical:!1,showsVerticalScrollIndicator:!0,contentContainerStyle:{flex:1,justifyContent:"center"},children:(0,x.jsx)(g.default,{style:{textAlign:"center"},children:t||"Not implemented yet"})})}var v=n(4942),b=n(6459),j=n(5222),O=n(8661),w=n(2306),P=n(1318);const S={grid:{grid:{flex:1},row:{flex:1,flexDirection:"row",alignItems:"center"},col:{flex:1}},card:{card:{margin:15,padding:10},content:{marginHorizontal:0,paddingHorizontal:10}},bottomBar:{backgroundColor:"aquamarine",position:"absolute",left:0,right:0,bottom:0},fab:{position:"absolute",right:16},chip:{measure:{display:"flex"},measure_text:{textAlign:"right"}},modal:{simple:{container:{display:"flex",alignSelf:"center",margin:20,padding:20},title:{textAlign:"center",marginBottom:10}}},numberPicker:{container:{position:"relative"},selectedIndicator:{position:"absolute",width:"100%",backgroundColor:"hsl(200, 8%, 94%)",borderRadius:5,top:"50%"}}};const C=function(){var e=(0,u.useSafeAreaInsets)().bottom,t=(0,p.useTheme)(),n=(0,P.useNavigation)(),o=(0,i.useState)(""),a=(0,r.default)(o,2),l=a[0],c=a[1];(0,i.useEffect)((function(){return n.addListener("state",(function(){var e,t=(null==(e=n.getCurrentRoute())?void 0:e.name)||"";c(t)}))}),[n]);return(0,x.jsxs)(O.default,{elevated:!0,style:[S.bottomBar.position,{height:80+e,backgroundColor:t.colors.elevation.level2}],safeAreaInsets:{bottom:e},children:[(0,x.jsx)(O.default.Action,{icon:"weather-partly-cloudy",onPress:function(){return n.navigate("Atmosphere")}}),(0,x.jsx)(O.default.Action,{icon:"calculator",onPress:function(){return n.navigate("Calculate")}}),(0,x.jsx)(O.default.Action,{icon:"table-large",onPress:function(){return n.navigate("Trajectory")}}),(0,x.jsx)(O.default.Action,{icon:"cog-outline",onPress:function(){return n.navigate("Settings")}}),(0,x.jsx)(w.default,{mode:"flat",size:"medium",icon:"Home"===l?"plus":"home",onPress:function(){"Home"!==l&&n.navigate("Home")},style:[S.fab,{top:12}]})]})};var k=n(9340),M="ios"===o.default.OS?"dots-horizontal":"dots-vertical";function V(e){var t=Object.assign({},((0,b.default)(e),e)),n=t.navigation,r=t.route,i=t.options,o=t.back,a=t.params,l=a.nightMode,c=a.toggleNightMode,s=(0,k.default)(i,r.name);return(0,x.jsxs)(O.default.Header,{elevated:!0,children:[o?(0,x.jsx)(O.default.BackAction,{onPress:n.goBack}):null,(0,x.jsx)(O.default.Content,{title:s}),(0,x.jsx)(O.default.Action,{icon:l?"brightness-7":"brightness-3",onPress:function(){return c(!l)}}),(0,x.jsx)(O.default.Action,{icon:M,onPress:function(){}})]})}var T=n(239),A=n(3982);const $=function(e){var t=e.children,n=e.title;return(0,x.jsxs)(A.default,{mode:"elevated",elevation:1,style:[S.card.card],children:[(0,x.jsx)(A.default.Title,{titleVariant:"titleLarge",title:n}),(0,x.jsx)(A.default.Content,{style:S.card.content,children:t})]})};var I=n(7970),D=n(582),U=n(5647),R=n(3555),E=n(9385);const z=function(e){var t=e.children,n=e.label,o=e.text,a=e.icon,l=void 0===a?null:a,c=e.onAccept,s=void 0===c?null:c,u=e.onDecline,d=void 0===u?null:u,f=i.useState(!1),h=(0,r.default)(f,2),g=h[0],y=h[1],m=function(){return y(!0)};return(0,x.jsxs)(E.default,{style:{display:"flex",justifyContent:"center"},children:[(0,x.jsx)(D.default,{icon:l,closeIcon:"square-edit-outline",style:{margin:0},textStyle:{fontSize:16},onPress:m,onClose:m,children:o}),(0,x.jsx)(U.default,{children:(0,x.jsxs)(R.default,{visible:g,onDismiss:function(){y(!1)},style:{justifyContent:"center"},children:[(0,x.jsx)(R.default.Title,{children:n}),(0,x.jsx)(R.default.Content,{children:t}),(0,x.jsxs)(R.default.Actions,{children:[(0,x.jsx)(w.default,{icon:"close",mode:"flat",size:"small",onPress:function(){d&&d(),y(!1)},variant:"tertiary",color:(0,p.useTheme)().colors.tertiary}),(0,x.jsx)(w.default,{icon:"check",mode:"flat",size:"small",onPress:function(){s&&s(),y(!1)}})]})]})})]})};var F=n(2982),L=n(9964);const W=y.default.create({container:{position:"relative"},selectedIndicator:{position:"absolute",width:"100%",backgroundColor:"hsl(200, 8%, 94%)",borderRadius:5,top:"50%"},scrollView:{overflow:"hidden",flex:1},option:{alignItems:"center",justifyContent:"center",paddingHorizontal:16,zIndex:100}});var N=n(1054);const H=i.memo((function(e){var t=e.textStyle,n=e.style,r=e.height,i=e.option,o=e.index,a=e.visibleRest,l=e.currentScrollIndex,c=e.opacityFunction,s=e.rotationFunction,u=e.scaleFunction,d=L.default.subtract(o,l),f=d.interpolate({inputRange:function(){for(var e=[0],t=1;t<=a+1;t++)e.unshift(-t),e.push(t);return e}(),outputRange:function(){for(var e=[0],t=1;t<=a+1;t++){for(var n=r/2*(1-Math.sin(Math.PI/2-s(t))),i=1;i<t;i++)n+=r*(1-Math.sin(Math.PI/2-s(i)));e.unshift(n),e.push(-n)}return e}()}),h=d.interpolate({inputRange:function(){for(var e=[0],t=1;t<=a+1;t++)e.unshift(-t),e.push(t);return e}(),outputRange:function(){for(var e=[1],t=1;t<=a+1;t++){var n=c(t);e.unshift(n),e.push(n)}return e}()}),p=d.interpolate({inputRange:function(){for(var e=[0],t=1;t<=a+1;t++)e.unshift(-t),e.push(t);return e}(),outputRange:function(){for(var e=[1],t=1;t<=a+1;t++){var n=u(t);e.unshift(n),e.push(n)}return e}()}),g=d.interpolate({inputRange:function(){for(var e=[0],t=1;t<=a+1;t++)e.unshift(-t),e.push(t);return e}(),outputRange:function(){for(var e=["0deg"],t=1;t<=a+1;t++){var n=s(t);e.unshift(`${n}deg`),e.push(`${n}deg`)}return e}()});return(0,x.jsx)(L.default.View,{style:[W.option,n,{height:r,opacity:h,transform:[{translateY:f},{rotateX:g},{scale:p}]}],children:(0,x.jsx)(N.default,{style:t,children:i})})}),(function(){return!0}));function B(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function G(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?B(Object(n),!0).forEach((function(t){(0,v.default)(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):B(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}const Y=function(e){var t=e.selectedIndex,n=e.options,a=e.onChange,l=e.selectedIndicatorStyle,c=void 0===l?{}:l,s=e.containerStyle,u=void 0===s?{}:s,d=e.itemStyle,f=void 0===d?{}:d,h=e.itemTextStyle,p=void 0===h?{}:h,g=e.itemHeight,y=void 0===g?40:g,m=e.scaleFunction,v=void 0===m?function(e){return 1**e}:m,b=e.rotationFunction,j=void 0===b?function(e){return 1-Math.pow(.5,e)}:b,O=e.opacityFunction,w=void 0===O?function(e){return Math.pow(1/3,e)}:O,P=e.visibleRest,S=void 0===P?2:P,C=e.decelerationRate,k=void 0===C?"fast":C,M=e.containerProps,V=void 0===M?{}:M,T=e.flatListProps,A=void 0===T?{}:T,$=(0,i.useRef)(null),I=(0,i.useState)(new L.default.Value(0)),D=(0,r.default)(I,1)[0],U=(0,i.useRef)((new Date).getTime()),R=(1+2*S)*y,z=(0,i.useState)(t),N=(0,r.default)(z,2),B=N[0],Y=N[1],_=(0,i.useMemo)((function(){for(var e=(0,F.default)(n),t=0;t<S;t++)e.unshift(null),e.push(null);return e}),[n,S]),X=(0,i.useMemo)((function(){return(0,F.default)(Array(_.length)).map((function(e,t){return t*y}))}),[_,y]),q=(0,i.useMemo)((function(){return L.default.add(L.default.divide(D,y),S)}),[S,D,y]);(0,i.useEffect)((function(){if(t<0||t>=n.length)throw new Error(`Selected index ${t} is out of bounds [0, ${n.length-1}]`)}),[t,n]),(0,i.useEffect)((function(){var e;null==(e=$.current)||e.scrollToIndex({index:t,animated:!1})}),[t]),(0,i.useEffect)((function(){if("web"===o.default.OS){var e=setInterval((function(){var e;(new Date).getTime()-U.current>500&&(null==(e=$.current)||e.scrollToIndex({index:B,animated:!0}))}),100);return function(){clearInterval(e)}}}),[B]),(0,i.useEffect)((function(){"web"===o.default.OS&&a(B)}),[B,a]);return(0,x.jsxs)(E.default,G(G({style:[W.container,{height:R},u]},V),{},{children:[(0,x.jsx)(E.default,{style:[W.selectedIndicator,c,{transform:[{translateY:-y/2}],height:y}]}),(0,x.jsx)(L.default.FlatList,G(G({},A),{},{ref:$,style:W.scrollView,showsVerticalScrollIndicator:!1,onScroll:L.default.event([{nativeEvent:{contentOffset:{y:D}}}],{useNativeDriver:!0,listener:function(e){return function(e){if("web"===o.default.OS){var t=e.nativeEvent.contentOffset.y,n=Math.round(t/y);Y(n),U.current=(new Date).getTime()}}(e)}}),onMomentumScrollEnd:function(e){var r=Math.min(y*(n.length-1),Math.max(e.nativeEvent.contentOffset.y,0)),i=Math.floor(Math.floor(r)/y);Math.floor(r%y)>y/2&&i++,i!==t&&a(i)},snapToOffsets:X,decelerationRate:k,initialScrollIndex:t,getItemLayout:function(e,t){return{length:y,offset:y*t,index:t}},data:_,keyExtractor:function(e,t){return t.toString()},renderItem:function(e){var t=e.item,n=e.index;return(0,x.jsx)(H,{index:n,option:t,style:f,textStyle:p,height:y,currentScrollIndex:q,scaleFunction:v,rotationFunction:j,opacityFunction:w,visibleRest:S},`option-${n}`)}}))]}))};function _(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function X(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?_(Object(n),!0).forEach((function(t){(0,v.default)(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):_(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}var q=function(e){for(var t=Object.assign({},((0,b.default)(e),e)),n=t.curValue,r=t.minValue,i=t.maxValue,o=t.onChange,a=t.wheelProps,l=[],c=Math.floor(r);c<=Math.floor(i);c++)l.push(c);return(0,x.jsx)(Y,X(X({},a),{},{selectedIndex:l.indexOf(n),options:l.map((function(e){return`${e}`})),onChange:function(e){o(l[e])}}))},J=function(e){var t=Object.assign({},((0,b.default)(e),e)),n=t.curValue,r=t.decimals,i=t.onChange,o=t.wheelProps,a=function(e){return(e%1).toFixed(r).slice(1)},l=1/10**r,c=function(){for(var e=[],t=0;t<1;t+=l)e.push(a(t));return e}();return(0,x.jsx)(Y,X(X({},o),{},{selectedIndex:c.indexOf(a(n)),options:c,onChange:function(e){i(parseFloat(c[e]))}}))};function Z(e){var t=Object.assign({},((0,b.default)(e),e)),n=t.curValue,o=(t.minValue,t.maxValue,t.decimals,t.onChange),a=(0,p.useTheme)(),l={selectedIndicatorStyle:X(X({},S.numberPicker.selectedIndicator),{},{borderRadius:0,backgroundColor:a.colors.onSecondary}),itemTextStyle:{color:a.colors.secondary,fontWeight:"bold",fontSize:24},containerStyle:X(X({},S.numberPicker.container),{},{backgroundColor:a.colors.secondaryContainer,marginTop:10})},c=X(X({},l),{},{containerStyle:X(X({},l.containerStyle),{},{borderTopLeftRadius:24,borderBottomLeftRadius:24}),itemStyle:{marginLeft:"auto",marginRight:0,paddingRight:5}}),s=X(X({},l),{},{containerStyle:X(X({},l.containerStyle),{},{borderTopRightRadius:24,borderBottomRightRadius:24}),itemStyle:{marginLeft:0,marginRight:"auto",paddingLeft:5}}),u=(0,i.useState)(Math.floor(n)),d=(0,r.default)(u,2),f=d[0],h=d[1],g=(0,i.useState)(n%1),y=(0,r.default)(g,2),m=y[0],v=y[1],j=function(e){o&&o(e+m)};return(0,x.jsxs)(E.default,{style:{flexDirection:"row",justifyContent:"center"},children:[(0,x.jsx)(q,X(X({wheelProps:c},X(X({},t),{},{curValue:f})),{},{onChange:function(e){h(e),j(e+m)}})),(0,x.jsx)(J,X(X({wheelProps:s},X(X({},t),{},{curValue:m})),{},{onChange:function(e){v(e),j(e+f)}}))]})}function K(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function Q(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?K(Object(n),!0).forEach((function(t){(0,v.default)(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):K(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function ee(e){for(var t=Object.assign({},((0,b.default)(e),e)),n=t.maxValue,r=t.minValue,i=t.onChange,o=t.curValue,a=(0,p.useTheme)(),l=[],c=r;c<=n;c++)l.push(c);var s={selectedIndicatorStyle:Q(Q({},S.numberPicker.selectedIndicator),{},{borderRadius:0,backgroundColor:a.colors.onSecondary}),containerStyle:Q(Q({},S.numberPicker.container),{},{backgroundColor:a.colors.secondaryContainer,borderRadius:24,marginTop:10}),itemTextStyle:{color:a.colors.secondary,fontWeight:"bold",fontSize:24}};return(0,x.jsx)(E.default,{style:{flexDirection:"row",justifyContent:"center"},children:(0,x.jsx)(Y,Q(Q({},s),{},{selectedIndex:l.indexOf(o),options:l,onChange:function(e){i&&i(l[e])}}))})}function te(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function ne(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?te(Object(n),!0).forEach((function(t){(0,v.default)(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):te(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function re(e){var t=e.field,n=(0,i.useState)(t.initialValue),o=(0,r.default)(n,2),a=o[0],l=o[1],c=(0,i.useState)(a),s=(0,r.default)(c,2),u=s[0],d=s[1],f=ne(ne({},t),{},{curValue:a,onChange:d}),h="int"===t.mode?(0,x.jsx)(ee,ne({},f)):(0,x.jsx)(Z,ne({},f));return(0,x.jsxs)(T.Row,{style:S.grid.row,children:[(0,x.jsx)(T.Col,{size:8,children:(0,x.jsx)(g.default,{style:{fontSize:16},children:t.label})}),(0,x.jsx)(T.Col,{size:8,children:(0,x.jsx)(z,{icon:t.icon,label:`${t.label}, ${t.suffix}`,text:`${a.toFixed(t.decimals)} ${t.suffix}`,onAccept:function(){l(u)},onDecline:function(){d(u)},children:h})})]})}function ie(){var e=[{key:"temp",label:"Temperature",suffix:I.UnitProps[I.Unit.Celsius].symbol,icon:"thermometer",mode:"int",initialValue:15,maxValue:50,minValue:-50,decimals:0},{key:"pressure",label:"Pressure",suffix:I.UnitProps[I.Unit.MmHg].symbol,icon:"speedometer",mode:"int",initialValue:760,maxValue:1e3,minValue:700,decimals:0},{key:"humidity",label:"Humidity",suffix:"%",icon:"water",mode:"int",initialValue:78,maxValue:100,minValue:0,decimals:0},{key:"altitude",label:"Altitude",suffix:I.UnitProps[I.Unit.Meter].symbol,icon:"ruler",mode:"int",initialValue:150,maxValue:3e3,minValue:0,decimals:0}];return(0,x.jsx)($,{title:"Current atmosphere",children:(0,x.jsx)(T.Grid,{style:S.grid.grid,children:e.map((function(e){return(0,x.jsx)(re,{field:e},e.key)}))})})}var oe=n(2557);function ae(e){var t=e.initialValue,n=e.onChange,o=e.items,a=(0,i.useState)(t),l=(0,r.default)(a,2),c=l[0],s=l[1];return(0,x.jsx)(oe.default.Group,{onValueChange:function(e){s(e),n&&n(e)},value:c,children:o.map((function(e){return(0,x.jsx)(oe.default.Item,{label:e.label,value:e.value},e.value)}))})}const le=function(e){var t=e.children,n=e.title,o=e.text,a=e.icon,l=void 0===a?null:a,c=e.onAccept,s=void 0===c?null:c,u=e.onDecline,d=void 0===u?null:u,f=i.useState(!1),g=(0,r.default)(f,2),y=g[0],m=g[1],v=function(){return m(!0)};return(0,x.jsxs)(E.default,{style:{display:"flex",justifyContent:"center"},children:[(0,x.jsx)(D.default,{icon:l,closeIcon:"square-edit-outline",style:{margin:0},textStyle:{fontSize:16},onPress:v,onClose:v,children:o}),(0,x.jsx)(U.default,{children:(0,x.jsxs)(R.default,{visible:y,onDismiss:function(){m(!1)},style:{justifyContent:"center"},children:[(0,x.jsx)(R.default.Title,{children:n}),(0,x.jsx)(R.default.ScrollArea,{children:(0,x.jsx)(h.default,{contentContainerStyle:{padding:24},children:t})}),(0,x.jsxs)(R.default.Actions,{children:[(0,x.jsx)(w.default,{icon:"close",mode:"flat",size:"small",onPress:function(){d&&d(),m(!1)},variant:"tertiary",color:(0,p.useTheme)().colors.tertiary}),(0,x.jsx)(w.default,{icon:"check",mode:"flat",size:"small",onPress:function(){s&&s(),m(!1)}})]})]})})]})};n(8822);function ce(){var e=(0,i.useState)("EN"),t=(0,r.default)(e,2),n=t[0],o=t[1],a=(0,i.useState)(n),l=(0,r.default)(a,2),c=l[0],s=l[1];return(0,x.jsx)($,{title:"General",children:(0,x.jsx)(T.Grid,{style:S.grid.grid,children:(0,x.jsxs)(T.Row,{style:S.grid.row,children:[(0,x.jsx)(T.Col,{size:9,children:(0,x.jsx)(g.default,{style:{fontSize:16},children:"Language"})}),(0,x.jsx)(T.Col,{size:7,children:(0,x.jsx)(le,{title:"Language",text:n,icon:"translate",onAccept:function(){o(c)},onDecline:function(){s(n)},children:(0,x.jsx)(ae,{initialValue:c,onChange:s,items:[{label:"English",value:"EN",key:"EN"},{label:"Ukrainian",value:"UA",key:"UA"}]})})})]})})})}var se=function(e){return Object.keys(e).map((function(t){return{label:I.UnitProps[e[t]].name,value:e[t]}}))},ue=[{key:"distance",label:"Distance",list:[{label:I.UnitProps[I.Unit.Meter].name,value:I.Unit.Meter},{label:I.UnitProps[I.Unit.Foot].name,value:I.Unit.Foot},{label:I.UnitProps[I.Unit.Yard].name,value:I.Unit.Yard}],def:I.Unit.Meter},{key:"velocity",label:"Velocity",list:[{label:I.UnitProps[I.Unit.MPS].name,value:I.Unit.MPS},{label:I.UnitProps[I.Unit.FPS].name,value:I.Unit.FPS}],def:I.Unit.MPS},{key:"angular",label:"Angular",list:se(I.Measure.Angular),def:I.Unit.Degree},{key:"sizes",label:"Sizes",list:[{label:I.UnitProps[I.Unit.Inch].name,value:I.Unit.Inch},{label:I.UnitProps[I.Unit.Millimeter].name,value:I.Unit.Millimeter},{label:I.UnitProps[I.Unit.Centimeter].name,value:I.Unit.Centimeter},{label:I.UnitProps[I.Unit.Centimeter].name,value:I.Unit.Line}],def:I.Unit.Inch},{key:"weight",label:"Weight",list:se(I.Measure.Weight),def:I.Unit.Grain},{key:"temperature",label:"Temperature",list:[{label:I.UnitProps[I.Unit.Celsius].name,value:I.Unit.Celsius},{label:I.UnitProps[I.Unit.Fahrenheit].name,value:I.Unit.Fahrenheit}],def:I.Unit.Celsius},{key:"pressure",label:"Pressure",list:se(I.Measure.Pressure),def:I.Unit.PSI},{key:"energy",label:"Energy",list:se(I.Measure.Energy),def:I.Unit.Joule},{key:"adjustment",label:"Adjustment",list:se(I.Measure.Angular),def:I.Unit.MIL}];function de(){var e=function(e){var t=e.field,n=(0,i.useState)(t.def),o=(0,r.default)(n,2),a=o[0],l=o[1],c=(0,i.useState)(a),s=(0,r.default)(c,2),u=s[0],d=s[1];return(0,x.jsxs)(T.Row,{style:S.grid.row,children:[(0,x.jsx)(T.Col,{size:9,children:(0,x.jsx)(g.default,{style:{fontSize:16},children:t.label})}),(0,x.jsx)(T.Col,{size:7,children:(0,x.jsx)(le,{title:t.label,text:I.UnitProps[a].name,onAccept:function(){l(u)},children:(0,x.jsx)(ae,{initialValue:a,onChange:d,items:t.list})})})]},t.key)};return(0,x.jsx)($,{title:"Units of measurement",children:(0,x.jsx)(T.Grid,{style:S.grid.grid,children:ue.map((function(t){return(0,x.jsx)(e,{field:t},t.key)}))})})}var fe=n(5783),he=n(2193);function pe(){var e=(0,p.useTheme)(),t=[{value:"Right",label:"Right",icon:"rotate-right",showSelectedCheck:!0,checkedColor:e.colors.primary},{value:"Left",label:"Left",icon:"rotate-left",showSelectedCheck:!0,checkedColor:e.colors.primary}],n=(0,i.useState)("Right"),o=(0,r.default)(n,2),a=o[0],l=o[1],c=(0,i.useState)(a),s=(0,r.default)(c,2),u=s[0],d=s[1],f=i.useState("My rifle"),h=(0,r.default)(f,2),y=h[0],m=h[1],v=i.useState(y),b=(0,r.default)(v,2),j=b[0],O=b[1];return(0,x.jsxs)($,{title:"Weapon",children:[(0,x.jsx)(z,{label:"Name",icon:"card-bulleted-outline",text:y,onAccept:function(){m(j)},onDecline:function(){O(y)},children:(0,x.jsx)(fe.default,{value:j,onChangeText:O})}),(0,x.jsxs)(T.Grid,{style:S.grid.grid,children:[[{key:"diameter",label:"Diameter",suffix:"in",icon:"diameter-variant",mode:"float",initialValue:.308,maxValue:22,minValue:.001,decimals:3},{key:"twist",label:"Twist",suffix:"in",icon:"screw-flat-top",mode:"float",initialValue:11,maxValue:20,minValue:-20,decimals:2}].map((function(e){return(0,x.jsx)(re,{field:e},e.key)})),(0,x.jsxs)(T.Row,{style:S.grid.row,children:[(0,x.jsx)(T.Col,{size:8,children:(0,x.jsx)(g.default,{style:{fontSize:16},children:"Twist direction"})}),(0,x.jsx)(T.Col,{size:8,children:(0,x.jsx)(z,{label:"Twist",icon:"Right"===a?"rotate-right":"rotate-left",text:a,onAccept:function(){l(u)},children:(0,x.jsx)(he.default,{buttons:t,value:u,onValueChange:d})})})]})]})]})}var ge=n(9188),ye=n(4584),xe=n(4710);function me(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function ve(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?me(Object(n),!0).forEach((function(t){(0,v.default)(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):me(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}const be=i.memo((function(e){for(var t=e.handleSize,n=void 0===t?15:t,o=e.handleColor,a=void 0===o?"#0cd":o,l=e.dialRadius,c=void 0===l?130:l,s=e.arcWidth,u=void 0===s?5:s,d=e.arcColor,f=void 0===d?"#0cd":d,h=e.meterTextColor,p=void 0===h?"#fff":h,g=e.fillColor,y=void 0===g?"none":g,m=e.strokeColor,v=void 0===m?"#fff":m,b=e.strokeWidth,j=void 0===b?.5:b,O=e.meterTextSize,w=void 0===O?10:O,P=e.value,S=void 0===P?0:P,C=e.minAngle,k=void 0===C?0:C,M=e.maxAngle,V=void 0===M?360:M,T=e.minValue,A=void 0===T?0:T,$=e.maxValue,I=void 0===$?360:$,D=e.xCenter,U=void 0===D?ye.default.get("window").width/2:D,R=e.yCenter,E=void 0===R?ye.default.get("window").height/2:R,z=e.onChange,F=void 0===z?function(e){return e}:z,L=e.coerceToInt,W=void 0!==L&&L,N=e.meterText,H=void 0===N?"None":N,B=(V-k)/(I-A),G=(0,i.useState)(S*B),Y=(0,r.default)(G,2),_=Y[0],X=Y[1],q=(0,i.useRef)(ge.default.create({onStartShouldSetPanResponder:function(e,t){return!0},onStartShouldSetPanResponderCapture:function(e,t){return!0},onMoveShouldSetPanResponder:function(e,t){return!0},onMoveShouldSetPanResponderCapture:function(e,t){return!0},onPanResponderMove:function(e,t){var r=U-(c+n),i=E-(c+n),o=Z(t.moveX-r,t.moveY-i);o<=k?X(k):o>=V?X(V):(W&&(o=Math.round(o/B)*B),X(o))}})).current,J=(0,i.useCallback)((function(e){var t=c,r=c+n,i=(e-90)*Math.PI/180;return{x:r+t*Math.cos(i),y:r+t*Math.sin(i)}}),[c,n]),Z=(0,i.useCallback)((function(e,t){var r=c+n;return 0===e?t>r?0:180:0===t?e>r?90:270:Math.round(180*Math.atan((t-r)/(e-r))/Math.PI)+(e>r?90:270)}),[c,n]),K=2*(c+n),Q=n,ee=c,te=J(0),ne=J(_),re=(B<=36?B:B/10)*Math.PI/180,ie=[],oe=V;oe>k;oe-=B)ie.push(Math.round(oe/B));var ae=K/2,le=ae+j/4,ce=ae-5*j/3;return(0,x.jsxs)(xe.default,{width:K+j,height:K,children:[(0,x.jsx)(xe.Circle,{r:ee,cx:K/2,cy:K/2,stroke:v,strokeWidth:j,fill:y}),(0,x.jsx)(xe.Path,{stroke:f,strokeWidth:u,fill:"none",d:`M${te.x} ${te.y} A ${ee} ${ee} 0 ${_>180?1:0} 1 ${ne.x} ${ne.y}`}),ie.map((function(e){return(0,x.jsx)(xe.Text,{x:ae+ce*Math.sin(e*re),y:le-ce*Math.cos(e*re),fontSize:12,fill:p,textAnchor:"middle",children:e},e)})),ie.map((function(e){return(0,x.jsx)(xe.Line,{x1:ae+(ae-j/3)*Math.sin(e*re),y1:ae-(ae-j/3)*Math.cos(e*re),x2:ae+ae*Math.sin(e*re),y2:ae-ae*Math.cos(e*re),stroke:a},`ticks${e}`)})),(0,x.jsx)(xe.Text,{x:ae,y:le+w/2,fontSize:w,fill:p,textAnchor:"middle",children:H}),(0,x.jsx)(xe.Circle,ve({r:ee+u,cx:ae,cy:ae,fill:"transparent"},q.panHandlers)),(0,x.jsx)(xe.G,{x:ne.x-Q,y:ne.y-Q,children:(0,x.jsx)(xe.Polygon,ve(ve({points:`\n                     ${Q},${Q+n}\n                     ${Q+n},${Q-n} \n                     ${Q-n},${Q-n} \n                    `,fill:a,transform:`rotate(${_} ${Q} ${Q})`},q.panHandlers),{},{children:function(e){return F(e/=B),e}(_)+""}))})]})}));function je(e){var t=e.value,n=e.minValue,r=e.maxValue,i=e.startAngle,o=e.endAngle;if(o<=i)throw new Error("endAngle must be greater than startAngle");return(t-n)/(r-n)*(o-i)+i}function Oe(e,t,n){if(n=n||{direction:"ccw",axis:"+x"},t.direction!==n.direction&&(e=0===e?0:360-e),t.axis===n.axis)return e;if(t.axis[1]===n.axis[1])return(180+e)%360;switch(n.direction+t.axis+n.axis){case"ccw+x-y":case"ccw-x+y":case"ccw+y+x":case"ccw-y-x":case"cw+y-x":case"cw-y+x":case"cw-x-y":case"cw+x+y":return(90+e)%360;case"ccw+y-x":case"ccw-y+x":case"ccw+x+y":case"ccw-x-y":case"cw+x-y":case"cw-x+y":case"cw+y+x":case"cw-y-x":return(270+e)%360;default:throw new Error("Unhandled conversion")}}function we(e,t,n){var r,i,o=Oe(e.degree,e,{direction:"ccw",axis:"+x"})/180*Math.PI;return o<=Math.PI?o<=Math.PI/2?(i=Math.sin(o)*t,r=Math.cos(o)*t):(i=Math.sin(Math.PI-o)*t,r=Math.cos(Math.PI-o)*t*-1):o<=1.5*Math.PI?(i=Math.sin(o-Math.PI)*t*-1,r=Math.cos(o-Math.PI)*t*-1):(i=Math.sin(2*Math.PI-o)*t*-1,r=Math.cos(2*Math.PI-o)*t),{x:r+n/2,y:n/2-i}}function Pe(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function Se(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?Pe(Object(n),!0).forEach((function(t){(0,v.default)(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):Pe(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function Ce(e){var t=e.startAngle,n=e.innerRadius,r=e.thickness,i=e.direction,o=e.angleType,a=e.svgSize,l=e.endAngle;t%360===l%360&&t!==l&&(l-=.001);var c=l-t>=180,s=n+r,u=we(Se({degree:t},o),n,a),d=`\n    M ${u.x},${u.y}\n  `,f=we(Se({degree:l},o),n,a),h=`\n    A ${n} ${n} 0\n      ${c?"1":"0"}\n      ${"cw"===i?"1":"0"}\n      ${f.x} ${f.y}\n  `,p=we(Se({degree:l},o),s,a),g=`\n    A ${r/2} ${r/2} 0\n      ${c?"1":"0"}\n      ${"cw"===i?"0":"1"}\n      ${p.x} ${p.y}\n  `,y=we(Se({degree:t},o),s,a);return d+h+g+`\n    A ${s} ${s} 0\n      ${c?"1":"0"}\n      ${"cw"===i?"0":"1"}\n      ${y.x} ${y.y}\n  `+`\n    A ${r/2} ${r/2} 0\n      ${c?"1":"0"}\n      ${"cw"===i?"0":"1"}\n      ${u.x} ${u.y}\n  `+" Z"}function ke(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function Me(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?ke(Object(n),!0).forEach((function(t){(0,v.default)(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):ke(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function Ve(e){for(var t=Object.assign({},((0,b.default)(e),e)),n=t.dialDiameter,r=void 0===n?200:n,o=t.strokeWidth,a=void 0===o?4:o,l=t.value,c=t.onChange,s=t.handle2,u=t.handleSize,d=void 0===u?8:u,f=t.maxValue,h=void 0===f?0:f,p=t.minValue,g=void 0===p?360:p,y=t.startAngle,m=void 0===y?0:y,v=t.endAngle,j=void 0===v?360:v,O=t.angleType,w=void 0===O?{direction:"cw",axis:"-y"}:O,P=t.disabled,S=t.arcColor,C=void 0===S?"#0cd":S,k=t.strokeColor,M=void 0===k?"#aaa":k,V=t.capMode,T=void 0===V?"triangle":V,A=t.handleColor,$=void 0===A?"#0cd":A,I=t.arcWidth,D=void 0===I?10:I,U=t.meterText,R=void 0===U?"None":U,E=t.meterTextColor,z=void 0===E?"#0cd":E,F=t.meterTextSize,L=void 0===F?10:F,W=t.coerceToInt,N=void 0!==W&&W,H=t.onControlFinished,B=(0,i.useRef)(null),G=function(e){var t=B.current;t&&(t.addEventListener("mousemove",_),t.addEventListener("mouseleave",Y),t.addEventListener("mouseup",Y)),_(e)},Y=function e(){var t=B.current;t&&(t.removeEventListener("mousemove",_),t.removeEventListener("mouseleave",e),t.removeEventListener("mouseup",e)),H&&H()},_=function(e){var t=e.clientX,n=e.clientY;q(t,n)},X=function(e){if(!(e.touches.length>1||"touchend"===e.type&&e.touches.length>0)){var t=e.changedTouches[0],n=t.clientX,r=t.clientY;q(n,r),"touchend"!==e.type&&"touchcancel"!==e.type||H&&H()}},q=function(e,t){var n;if(c){var i=B.current;if(i){var o=i.createSVGPoint();o.x=e,o.y=t;var a=function(e,t,n){var r=e.x-t/2,i=t/2-e.y,o=Math.atan2(i,r);return o<0&&(o+=2*Math.PI),Oe(o/Math.PI*180,{direction:"ccw",axis:"+x"},n)}(o.matrixTransform(null==(n=i.getScreenCTM())?void 0:n.inverse()),r,w),u=function(e){var t=e.angle,n=e.minValue,r=e.maxValue,i=e.startAngle,o=e.endAngle;if(o<=i)throw new Error("endAngle must be greater than startAngle");return t<i?n:t>o?r:(t-i)/(o-i)*(r-n)+n}({angle:a,minValue:g,maxValue:h,startAngle:m,endAngle:j});N&&(u=Math.round(u)),P||(s&&s.onChange&&Math.abs(u-s.value)<Math.abs(u-l)?s.onChange(u):c(u))}}},J=r/2-a-20,Z=je({value:l,minValue:g,maxValue:h,startAngle:m,endAngle:j}),K=s&&je({value:s.value,minValue:g,maxValue:h,startAngle:m,endAngle:j}),Q=we(Me({degree:Z},w),J+a/2,r),ee=K&&we(Me({degree:K},w),J+a/2,r),te=!P&&Boolean(c),ne=(j-m)/(h-g),re=(ne<=36?ne:ne/10)*Math.PI/180,ie=r/2,oe=ie+a/4,ae=[],le=j;le>m;le-=ne)ae.push(Math.round(le/ne));return(0,x.jsxs)("svg",{width:r,height:r,ref:B,onMouseDown:G,onMouseEnter:function(e){1===e.buttons&&G(e)},onClick:function(e){return te&&e.stopPropagation()},onTouchStart:X,onTouchEnd:X,onTouchMove:X,onTouchCancel:X,style:{touchAction:"none"},children:[void 0===K?(0,x.jsxs)(i.Fragment,{children:[(0,x.jsx)("path",{d:Ce({startAngle:Z,endAngle:j,angleType:w,innerRadius:J,thickness:a,svgSize:r,direction:w.direction}),fill:M}),(0,x.jsx)("path",{d:Ce({startAngle:m,endAngle:Z,angleType:w,innerRadius:J+a/2-D/2,thickness:D,svgSize:r,direction:w.direction}),fill:C})]}):(0,x.jsxs)(i.Fragment,{children:[(0,x.jsx)("path",{d:Ce({startAngle:m,endAngle:Z,angleType:w,innerRadius:J,thickness:a,svgSize:r,direction:w.direction}),fill:M}),(0,x.jsx)("path",{d:Ce({startAngle:K,endAngle:j,angleType:w,innerRadius:J,thickness:a,svgSize:r,direction:w.direction}),fill:M}),(0,x.jsx)("path",{d:Ce({startAngle:Z,endAngle:K,angleType:w,innerRadius:J,thickness:a,svgSize:r,direction:w.direction}),fill:C})]}),ae.map((function(e){return(0,x.jsx)("text",{x:ie+(J-a/2)*Math.sin(e*re),y:oe-(J-a/2)*Math.cos(e*re),fontSize:12,fill:$,textAnchor:"middle",children:e},e)})),ae.map((function(e){return(0,x.jsx)("line",{x1:ie+(J+2/3*a)*Math.sin(e*re),y1:ie-(J+2/3*a)*Math.cos(e*re),x2:ie+(J+a)*Math.sin(e*re),y2:ie-(J+a)*Math.cos(e*re),stroke:$},`ticks${e}`)})),(0,x.jsxs)("text",{x:r/2,y:r/2+10,fontSize:L,fill:z,textAnchor:"middle",children:[R," "]}),te&&(0,x.jsx)(i.Fragment,{children:function(){var e=l*((j-m)/(h-g))+180;return"triangle"===T?(0,x.jsx)("polygon",{points:`${Q.x},${Q.y-d} \n             ${Q.x-d},${Q.y+d} \n             ${Q.x+d},${Q.y+d}`,fill:$,transform:`rotate(${e} ${Q.x} ${Q.y})`}):(0,x.jsx)("circle",{r:d,cx:Q.x,cy:Q.y,fill:"#ffffff"})}()}),ee&&(0,x.jsx)(i.Fragment,{children:(0,x.jsx)("circle",{r:d,cx:ee.x,cy:ee.y,fill:"#ffffff"})})]})}function Te(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function Ae(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?Te(Object(n),!0).forEach((function(t){(0,v.default)(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):Te(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function $e(e){var t=e.value,n=e.onChange,r=(0,p.useTheme)(),i={container:{justifyContent:"center",alignItems:"center",paddingBottom:40},text:{marginTop:-110,fontWeight:"bold",fontSize:16,textAlign:"center"},slider:{padding:5}},a={coerceToInt:!0,handleSize:10,arcWidth:20,strokeWidth:20,meterTextSize:20,handleColor:r.colors.outline,arcColor:r.colors.secondaryContainer,strokeColor:r.colors.secondaryContainer,meterTextColor:r.colors.outline},l={minValue:0,maxValue:12,meterText:`${30*t}\xb0 (${t}h)`},c={value:t,onChange:n};return(0,x.jsx)(E.default,{style:i.container,children:"web"===o.default.OS?(0,x.jsx)(Ve,Ae(Ae(Ae(Ae({},c),a),l),{},{style:i.slider,dialDiameter:240,angleType:{direction:"cw",axis:"+y"}})):(0,x.jsx)(be,Ae(Ae(Ae(Ae({},c),a),l),{},{style:i.slider,dialRadius:80}))})}function Ie(){var e=[{key:"windSpeed",label:"Wind speed",suffix:I.UnitProps[I.Unit.MPS].symbol,icon:"windsock",mode:"float",initialValue:0,maxValue:100,minValue:0,decimals:1}],t=(0,i.useState)(0),n=(0,r.default)(t,2),o=n[0],a=n[1],l=(0,i.useState)(o/30),c=(0,r.default)(l,2),s=c[0],u=c[1];return(0,x.jsx)($,{title:"Current wind",children:(0,x.jsxs)(T.Grid,{style:S.grid.grid,children:[e.map((function(e){return(0,x.jsx)(re,{field:e},e.key)})),(0,x.jsxs)(T.Row,{style:S.grid.row,children:[(0,x.jsx)(T.Col,{children:(0,x.jsx)(g.default,{style:{fontSize:16},children:"Wind direction"})}),(0,x.jsx)(T.Col,{children:(0,x.jsx)(z,{label:"Wind direction, degree",text:`${o}\xb0 (${o/30}h)`,icon:function(){switch(o/30){case 12:case 0:return"clock-time-twelve-outline";case 11:return"clock-time-eleven-outline";case 10:return"clock-time-ten-outline";case 9:return"clock-time-nine-outline";case 8:return"clock-time-eight-outline";case 7:return"clock-time-seven-outline";case 6:return"clock-time-six-outline";case 5:return"clock-time-five-outline";case 4:return"clock-time-four-outline";case 3:return"clock-time-three-outline";case 2:return"clock-time-two-outline";case 1:return"clock-time-one-outline"}}(),onAccept:function(){a(30*s)},onDecline:function(){u(o/30)},children:(0,x.jsx)($e,{value:s,onChange:function(e){u(12===e?0:e)}})})})]})]})})}n(6267);function De(e){e.navigation;var t=(0,p.useTheme)(),n=y.default.create({scrollViewContainer:{backgroundColor:t.colors.background}});return(0,x.jsx)(x.Fragment,{children:(0,x.jsx)(h.default,{style:n.scrollViewContainer,keyboardShouldPersistTaps:"always",alwaysBounceVertical:!1,showsVerticalScrollIndicator:!0,children:(0,x.jsx)(pe,{})})})}function Ue(e){e.navigation;var t=(0,p.useTheme)(),n=y.default.create({scrollViewContainer:{backgroundColor:t.colors.background}});return(0,x.jsxs)(h.default,{style:n.scrollViewContainer,keyboardShouldPersistTaps:"always",alwaysBounceVertical:!1,showsVerticalScrollIndicator:!0,children:[(0,x.jsx)(ie,{}),(0,x.jsx)(Ie,{})]})}function Re(e){e.props;var t={scrollViewContainer:{backgroundColor:(0,p.useTheme)().colors.background}};return(0,x.jsxs)(h.default,{style:t.scrollViewContainer,keyboardShouldPersistTaps:"always",alwaysBounceVertical:!1,showsVerticalScrollIndicator:!0,children:[(0,x.jsx)(ce,{}),(0,x.jsx)(de,{})]})}function Ee(e){e.navigation;return(0,x.jsx)(m,{text:"Calculator\nnot implemented yet"})}function ze(e){e.navigation;return(0,x.jsx)(m,{text:"Trajectory table\nnot implemented yet"})}var Fe=(0,P.createNavigationContainerRef)();function Le(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function We(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?Le(Object(n),!0).forEach((function(t){(0,v.default)(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):Le(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}var Ne=(0,d.default)();function He(e){var t=Object.assign({},((0,b.default)(e),e)),n=t.nightMode,r=t.toggleNightMode;return(0,x.jsxs)(j.default,{ref:Fe,children:[(0,x.jsxs)(Ne.Navigator,{initialRouteName:"Home",screenOptions:{header:function(e){return(0,x.jsx)(V,We(We({},e),{},{params:{nightMode:n,toggleNightMode:r}}))}},children:[(0,x.jsx)(Ne.Screen,{name:"Home",component:De}),(0,x.jsx)(Ne.Screen,{name:"Atmosphere",component:Ue}),(0,x.jsx)(Ne.Screen,{name:"Calculate",component:Ee}),(0,x.jsx)(Ne.Screen,{name:"Trajectory",component:ze}),(0,x.jsx)(Ne.Screen,{name:"Settings",component:Re})]}),(0,x.jsx)(C,{})]})}(0,d.default)();function Be(){var e=(0,i.useState)(!0),t=(0,r.default)(e,2),n=t[0],d=t[1],h=n?l.MD3DarkTheme:c.MD3LightTheme,p={provider:{flex:1,backgroundColor:h.colors.background}};return"web"!==o.default.OS||f.isMobile?(0,x.jsx)(u.SafeAreaProvider,{style:p.provider,children:(0,x.jsxs)(s.default,{theme:h,children:[(0,x.jsx)(He,{nightMode:n,toggleNightMode:function(){d((function(e){return!e}))}}),(0,x.jsx)(a.default,{style:"auto"})]})}):(0,x.jsx)(m,{text:"Oops! The app supports only mobile view"})}}},t={};function n(r){var i=t[r];if(void 0!==i)return i.exports;var o=t[r]={exports:{}};return e[r].call(o.exports,o,o.exports,n),o.exports}n.m=e,n.amdO={},(()=>{var e=[];n.O=(t,r,i,o)=>{if(!r){var a=1/0;for(u=0;u<e.length;u++){for(var[r,i,o]=e[u],l=!0,c=0;c<r.length;c++)(!1&o||a>=o)&&Object.keys(n.O).every((e=>n.O[e](r[c])))?r.splice(c--,1):(l=!1,o<a&&(a=o));if(l){e.splice(u--,1);var s=i();void 0!==s&&(t=s)}}return t}o=o||0;for(var u=e.length;u>0&&e[u-1][2]>o;u--)e[u]=e[u-1];e[u]=[r,i,o]}})(),n.n=e=>{var t=e&&e.__esModule?()=>e.default:()=>e;return n.d(t,{a:t}),t},n.d=(e,t)=>{for(var r in t)n.o(t,r)&&!n.o(e,r)&&Object.defineProperty(e,r,{enumerable:!0,get:t[r]})},n.g=function(){if("object"===typeof globalThis)return globalThis;try{return this||new Function("return this")()}catch(e){if("object"===typeof window)return window}}(),n.o=(e,t)=>Object.prototype.hasOwnProperty.call(e,t),n.r=e=>{"undefined"!==typeof Symbol&&Symbol.toStringTag&&Object.defineProperty(e,Symbol.toStringTag,{value:"Module"}),Object.defineProperty(e,"__esModule",{value:!0})},n.p="/ebalistyka/",(()=>{var e={179:0};n.O.j=t=>0===e[t];var t=(t,r)=>{var i,o,[a,l,c]=r,s=0;if(a.some((t=>0!==e[t]))){for(i in l)n.o(l,i)&&(n.m[i]=l[i]);if(c)var u=c(n)}for(t&&t(r);s<a.length;s++)o=a[s],n.o(e,o)&&e[o]&&e[o][0](),e[o]=0;return n.O(u)},r=self.webpackChunkweb=self.webpackChunkweb||[];r.forEach(t.bind(null,0)),r.push=t.bind(null,r.push.bind(r))})();var r=n.O(void 0,[36],(()=>n(6271)));r=n.O(r)})();
//# sourceMappingURL=main.045b4606.js.map