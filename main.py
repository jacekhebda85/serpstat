indices = ['ads', 'keywords', 'positions', 'rating', 'suggestions']

for index in indices:

    output = []

    with open(f'original_data/serpstat_ua_{index}.json', 'r') as file:
        lines= file.readlines()
        for line in lines:
            id=line.split('"')[3]
            output.append('{"index":{"_id":"'+id+'"}}\n')
            output.append(line.split('_source": ')[1].replace("}}", "}"))
    with open(f'serpstat_ua_{index}.json', 'w', encoding='utf-8') as file: 
        file.writelines(output)
