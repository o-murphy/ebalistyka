import React, {useEffect, useState} from 'react';
import {Appbar, FAB, useTheme} from 'react-native-paper';
import {useSafeAreaInsets} from 'react-native-safe-area-context';
import { useNavigation } from "@react-navigation/native";
import styleSheet from "../../styles/stylesheet";


const BOTTOM_APPBAR_HEIGHT = 80;
const MEDIUM_FAB_HEIGHT = 56;

const BotAppBar = () => {
    const {bottom} = useSafeAreaInsets();
    const theme = useTheme();

    const navigation: any = useNavigation()

    const [currentRoute, setCurrentRoute] = useState('');
    useEffect(() => {
        return navigation.addListener('state', () => {
            const currentRouteName = navigation.getCurrentRoute()?.name || '';
            setCurrentRoute(currentRouteName);
        });
    }, [navigation]);

    const onFabPress = () => {
        if (!(currentRoute === "Home")) {
            navigation.navigate("Home")
        }
    }

    return (
        <Appbar
            elevated={true}
            style={[
                styleSheet.bottomBar.position,
                {
                    height: BOTTOM_APPBAR_HEIGHT + bottom,
                    backgroundColor: theme.colors.elevation.level2,
                },
            ]}
            safeAreaInsets={{bottom}}
        >

            <Appbar.Action icon="hydraulic-oil-temperature" onPress={() => navigation.navigate("Atmosphere")}/>
            <Appbar.Action icon="cog-outline" onPress={() => navigation.navigate("Settings")}/>

            <FAB
                mode="flat"
                size="medium"
                icon={currentRoute === "Home" ? "plus" : "home"}
                onPress={onFabPress}
                style={[
                    styleSheet.fab,
                    {top: (BOTTOM_APPBAR_HEIGHT - MEDIUM_FAB_HEIGHT) / 2},
                ]}
            />

        </Appbar>
    );
};


export default BotAppBar;