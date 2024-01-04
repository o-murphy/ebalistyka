import * as React from 'react';
import {Portal, Chip, useTheme, Button, Dialog} from 'react-native-paper';
import {ScrollView, View} from "react-native";
import styleSheet from "../../styles/stylesheet";


const SimpleModal = ({
                         children,
                         title,
                         text,
                         icon = null,
                         onAccept = null,
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

    return (
        <View style={{display: "flex", justifyContent: "center"}}>
            <Chip icon={icon} closeIcon="square-edit-outline"
                  onPress={showDialog}
                  onClose={showDialog}
            >
                {text}
            </Chip>
            <Portal>
                <Dialog visible={visible} onDismiss={hideDialog}>
                    <Dialog.Title>{title}</Dialog.Title>
                    <Dialog.Content>
                        {children}
                        {onAccept ? <Button
                            style={styleSheet.modal.simple.closeButton}
                            icon={"check"}
                            mode={"elevated"}
                            onPress={onAcceptBtn}>
                            {"Ok"}
                        </Button> : null}
                    </Dialog.Content>
                </Dialog>
            </Portal>
        </View>
    );
};

export default SimpleModal;