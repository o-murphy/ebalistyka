


import React from 'react';
import {NavigationContainer} from '@react-navigation/native';
import {createNativeStackNavigator} from '@react-navigation/native-stack';

import {TopAppBar, BotAppBar} from "./components/app-bars";
import {MunitionScreen, CurrentAtmo, SettingsScreen, Calculate, Trajectory} from "./screens";

import {navigationRef} from "./RootNavigation";
import DragModelScreen from "./screens/drag-model/DragModelScreen";
import HomeScreen from "./screens/home/HomeScreen";


const Stack = createNativeStackNavigator();


export default function RootScreenManager({...props}) {

    const {nightMode, toggleNightMode} = props

    return (

                <NavigationContainer ref={navigationRef}>
                    <Stack.Navigator
                        initialRouteName="Munition"
                        screenOptions={{
                            header: (props) => <TopAppBar {...props}
                                                          params={{nightMode, toggleNightMode}}
                            />,
                        }}
                    >

                        <Stack.Screen name="Home" component={HomeScreen}/>
                        <Stack.Screen name="Munition" component={MunitionScreen}/>
                        <Stack.Screen name="Atmosphere" component={CurrentAtmo}/>
                        <Stack.Screen name="Calculate" component={Calculate}/>
                        <Stack.Screen name="Trajectory" component={Trajectory}/>
                        <Stack.Screen name="Settings" component={SettingsScreen}/>
                        <Stack.Screen name="DragModelScreen" component={DragModelScreen}/>

                    </Stack.Navigator>
                    <BotAppBar/>

                </NavigationContainer>

    );
}