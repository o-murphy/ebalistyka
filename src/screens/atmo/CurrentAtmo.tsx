import React from "react";
import {View, ScrollView, Dimensions} from 'react-native';
import {Button, Text, useTheme} from 'react-native-paper';
import {StyleSheet} from "react-native";
import AtmoCard from "../../components/atmo-card/AtmoCard";


export default function CurrentAtmo({ navigation }) {

    const theme = useTheme();

    const styles = StyleSheet.create({
        grid: {
            flex: 1,
            alignItems: 'flex-start',
            justifyContent: 'flex-start',
            backgroundColor: theme.colors.background
        },
        row: {
            flex: 1,
            alignItems: "center",
        },
        col: {
            flex: 1,
        },
        scrollViewContainer: {
            backgroundColor: theme.colors.background,
            height: Dimensions.get('window').height * 0.8, // Set the height as a percentage of the screen height
            marginBottom: 80
        },
    });

    return (
        <ScrollView
            style={styles.scrollViewContainer}
            keyboardShouldPersistTaps="always"
            alwaysBounceVertical={false}
            showsVerticalScrollIndicator={true}
        >
        <AtmoCard />
        </ScrollView>
    );
}
