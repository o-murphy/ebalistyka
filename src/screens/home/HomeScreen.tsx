import React from "react";
import {ScrollView} from 'react-native';
import {FAB, useTheme} from 'react-native-paper';
import {StyleSheet} from "react-native";
import {WeaponCard} from "../../components/cards";
import styleSheet from "../../styles";
import TabsCard from "../../components/cards/TabsCard";


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
       <>
            <ScrollView
                style={styles.scrollViewContainer}
                keyboardShouldPersistTaps="always"
                alwaysBounceVertical={false}
                showsVerticalScrollIndicator={true}
            >
                <WeaponCard/>

                <TabsCard />
            </ScrollView>
            {/*TODO: move fab to screen*/}
            {/*<FAB*/}
            {/*    mode="flat"*/}
            {/*    size="medium"*/}
            {/*    icon={"plus"}*/}
            {/*    onPress={() => console.log("BigFabPressed")}*/}
            {/*    style={[*/}
            {/*        styleSheet.fab,*/}
            {/*        {bottom: (BOTTOM_APPBAR_HEIGHT - MEDIUM_FAB_HEIGHT) / 2},*/}
            {/*    ]}*/}
            {/*/>*/}
        </>
    );
}
