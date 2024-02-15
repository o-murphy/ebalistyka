import {MeasureField} from "../../measure-slider-modal/MeasureSliderModal";
import {useState} from "react";
import {FloatPicker, IntPicker} from "../../number-picker";
import SimpleDialog from "../../dialogs/SimpleDialog";


export default function TableValuePicker({field}: MeasureField) {
    const [curValue, setCurValue] = useState(field.initialValue);
    const [value, setValue] = useState(curValue)

    const onAccept = () => {
        setCurValue(value)
    }

    const onDecline = () => {
        setValue(value)
    }

    const pickerProps = {
        ...field,
        curValue: curValue,
        onChange: setValue
    }

    const picker = field.mode === "int"
        ? <IntPicker {...pickerProps}/>
        : <FloatPicker {...pickerProps}/>

            return (
                <SimpleDialog icon={field.icon} label={`${field.label}` + (field.suffix ? `, ${field.suffix}` : "")}
            text={`${curValue.toFixed(field.decimals)} ${field.suffix}`}
            onAccept={onAccept}
            onDecline={onDecline}>
                {picker}
                </SimpleDialog>
        )
}