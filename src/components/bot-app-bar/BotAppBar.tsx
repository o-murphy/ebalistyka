import React, {useEffect, useState} from 'react';
import {StyleSheet} from 'react-native';
import {Appbar, FAB, useTheme} from 'react-native-paper';
import {useSafeAreaInsets} from 'react-native-safe-area-context';
import { useNavigation } from "@react-navigation/native";


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
                styles.bottom,
                {
                    height: BOTTOM_APPBAR_HEIGHT + bottom,
                    backgroundColor: theme.colors.elevation.level2,
                },
            ]}
            safeAreaInsets={{bottom}}
        >



            <Appbar.Action icon="hydraulic-oil-temperature" onPress={() => navigation.navigate("Atmosphere")}/>
            <Appbar.Action icon="cog-outline" onPress={() => navigation.navigate("Settings")}/>

            {/*{currentRoute === 'Home' ? null : (*/}
            {/*    <Appbar.Action icon="home" onPress={() => navigation.navigate('Home')}/>*/}
            {/*)}*/}

            {/*{currentRoute === 'Home' ? <FAB*/}
            {/*    mode="flat"*/}
            {/*    size="medium"*/}
            {/*    icon="plus"*/}
            {/*    onPress={() => {*/}
            {/*    }}*/}
            {/*    style={[*/}
            {/*        styles.fab,*/}
            {/*        {top: (BOTTOM_APPBAR_HEIGHT - MEDIUM_FAB_HEIGHT) / 2},*/}
            {/*    ]}*/}
            {/*/> : null}*/}

            <FAB
                mode="flat"
                size="medium"
                icon={currentRoute === "Home" ? "plus" : "home"}
                onPress={onFabPress}
                style={[
                    styles.fab,
                    {top: (BOTTOM_APPBAR_HEIGHT - MEDIUM_FAB_HEIGHT) / 2},
                ]}
            />

        </Appbar>
    );
};

const styles = StyleSheet.create({
    bottom: {
        backgroundColor: 'aquamarine',
        position: 'absolute',
        left: 0,
        right: 0,
        bottom: 0,
    },
    fab: {
        position: 'absolute',
        right: 16,
    },
});

export default BotAppBar;