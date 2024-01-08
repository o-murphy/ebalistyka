import * as React from 'react';
import {Portal, Chip, useTheme, Button, Dialog, Text, FAB} from 'react-native-paper';
import {ScrollView, View} from "react-native";


const SimpleDialog = ({
                         children,
                         title,
                         text,
                         icon = null,
                         onAccept = null,
                         onDecline = null
                     }) => {

    const [visible, setVisible] = React.useState(false);

    const showDialog = () => setVisible(true);
    const hideDialog = () => {
        setVisible(false);
    };

    const onAcceptBtn = () => {
        if (onAccept) onAccept();
        setVisible(false);
    }

    const onDeclineBtn = () => {
        if (onDecline) onDecline();
        setVisible(false);
    }

    return (
        <View style={{display: "flex", justifyContent: "center"}}>
            <Chip icon={icon} closeIcon="square-edit-outline" style={{margin: 0}} textStyle={{fontSize: 16}}
                  onPress={showDialog}
                  onClose={showDialog}
                // textStyle={{fontSize: 18}}
            >
                {text}
            </Chip>
            <Portal>

                <Dialog visible={visible} onDismiss={hideDialog} style={{justifyContent: "center"}}>
                    <Dialog.Title>{title}</Dialog.Title>

                    <Dialog.ScrollArea>
                        <ScrollView contentContainerStyle={{padding: 24}}>
                            {children}
                        </ScrollView>
                    </Dialog.ScrollArea>

                    <Dialog.Actions>
                        <FAB icon="close" size={'small'} onPress={onDeclineBtn}
                             variant={'tertiary'} color={useTheme().colors.error}/>
                        <FAB icon="check" size={'small'} onPress={onAcceptBtn}/>
                    </Dialog.Actions>
                </Dialog>

            </Portal>
        </View>
    );
};

export default SimpleDialog;