import React from "react";
import {ScrollView} from 'react-native';
import {useTheme} from 'react-native-paper';
import {StyleSheet} from "react-native";
import {WeaponCard} from "../../components/cards";


export default function HomeScreen({navigation}) {

    const theme = useTheme();

    const styles = StyleSheet.create({
        scrollViewContainer: {
            backgroundColor: theme.colors.background,
            // height: Dimensions.get('window').height * 0.8, // Set the height as a percentage of the screen height
            // marginBottom: 80
        },
    });

    return (
        <ScrollView
            style={styles.scrollViewContainer}
            keyboardShouldPersistTaps="always"
            alwaysBounceVertical={false}
            showsVerticalScrollIndicator={true}
        >
            <WeaponCard/>
        </ScrollView>
    );
}
