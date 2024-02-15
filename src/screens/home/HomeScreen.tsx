import React from "react";
import {ScrollView} from 'react-native';
import {useTheme} from 'react-native-paper';
import {StyleSheet} from "react-native";
import {WeaponCard} from "../../components/cards";
import TabsCard from "../../components/cards/TabsCard";
import ProjectileCard from "../../components/cards/ProjectileCard";
import BulletCard from "../../components/cards/BulletCard";
import Placeholder from "../placeholder/Placeholder";
// import UserDataExample from "../../user-data/UseUserDataHookExample";


export default function HomeScreen({navigation}) {

    const theme = useTheme();

    const styles = StyleSheet.create({
        scrollViewContainer: {
            backgroundColor: theme.colors.background,
        },
    });

    return (
        <>
            <ScrollView
                style={styles.scrollViewContainer}
                keyboardShouldPersistTaps="always"
                alwaysBounceVertical={false}
                showsVerticalScrollIndicator={true}
            >

            <Placeholder text={"Here will be a list of profiles\n\nNot implemented yet"} />
            {/*<UserDataExample />*/}
            </ScrollView>
        </>
    );
}
