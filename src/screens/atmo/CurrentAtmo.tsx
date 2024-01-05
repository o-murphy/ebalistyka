import React from "react";
import {ScrollView} from 'react-native';
import {useTheme} from 'react-native-paper';
import {StyleSheet} from "react-native";
import AtmoCard from "../../components/atmo-card/AtmoCard";
import WindCard from "../../components/wind-card/WindCard";


export default function CurrentAtmo({ navigation }) {

    const theme = useTheme();

    const styles = StyleSheet.create({
        scrollViewContainer: {
            backgroundColor: theme.colors.background,
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
            <WindCard />
        </ScrollView>
    );
}
